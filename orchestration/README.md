# Orchestration & datalake-architectuur

Dit document beschrijft hoe dit dbt-project in productie tegen Fabric draait:
CI/CD (GitHub Actions), orchestration (Fabric Data Pipeline) en het
datalake-ingestiepatroon. Het is bewust als **scaffolding** opgezet: alle
code/config staat klaar, maar sommige stappen kunnen pas echt draaien zodra er
een Fabric-workspace + service principal beschikbaar is.

## Architectuurplaat

Live opzet in de dev-workspace ("DEV"):

```
bronsystemen / sample CSV's
        |
        v
Lakehouse "Landing_bron_data"  (Tables/dbo/<tabel>, Delta)
        |  Fabric cross-database query (workspace-niveau, geen kopie/shortcut)
        v
Warehouse "dbt_raw"  <-- dbt verbindt hierop (profiles.yml database: dbt_raw)
        |
        v  dbt source('raw', ...) -> staging (views) -> marts (tables)
Warehouse "dbt_raw"  (schema "staging", "marts")
```

`models/staging/_sources.yml` wijst met `database: Landing_bron_data` /
`schema: dbo` naar de Lakehouse-tabellen; dbt genereert daarmee automatisch
drie-delige namen (`[Landing_bron_data].[dbo].[tabel]`) die Fabric's
cross-database querying ondersteunt vanuit het Warehouse `dbt_raw` - geen
shortcuts nodig zolang Lakehouse en Warehouse in dezelfde workspace staan.

Voor lokale/offline demo's blijft er ook een kortere route: de sample-CSV's
in `seeds/` gaan via `dbt seed` rechtstreeks het Warehouse in, zonder de
Lakehouse-laag.

**Als de trial-capacity de Spark-sessie van het notebook niet start** (typisch
"Session error or stopped" op een uitgeputte/gethrottelde trial-capacity):
gebruik `orchestration/copy_into_dbt_raw.sql` als Spark-vrij alternatief. Dat
script laadt de CSV's met `COPY INTO` (T-SQL) rechtstreeks in schema `raw`
van het Warehouse `dbt_raw` zelf, zonder Lakehouse/Spark. Bij gebruik van dit
alternatief: verwijder `database: Landing_bron_data` uit
`models/staging/_sources.yml` (de tabellen staan dan al in dezelfde database
als waar dbt op verbindt).

## 1. CI/CD - GitHub Actions

`.github/workflows/ci.yml` draait op elke PR en push naar `main`:

1. `dbt deps` + `dbt parse` - altijd, valideert Jinja/YAML/config zonder
   Fabric-verbinding.
2. Als de GitHub Secrets hieronder ingesteld zijn: installeert de ODBC-driver
   en draait `dbt seed` + `dbt build` tegen een tijdelijk CI-schema
   (`ci_pr_<nummer>`) in het Fabric warehouse.
3. Zonder secrets: stap 2 wordt overgeslagen met een duidelijke notice, de PR
   faalt niet.

Benodigde **GitHub Secrets** (Settings -> Secrets and variables -> Actions),
van een service principal met minimaal `db_datareader`/`db_datawriter` +
schema-create rechten op een dev/test Fabric warehouse:

| Secret | Betekenis |
|---|---|
| `FABRIC_SERVER` | `<workspace>.datawarehouse.fabric.microsoft.com` |
| `FABRIC_DATABASE` | Naam van het (dev/test) Fabric warehouse |
| `FABRIC_CLIENT_ID` | App-registratie (service principal) client id |
| `FABRIC_CLIENT_SECRET` | Service principal secret |
| `FABRIC_TENANT_ID` | Entra ID tenant id |

Het CI-profiel zelf (`profiles/profiles.yml`) bevat geen secrets - het leest
alles uit environment variables via `env_var()`, dus dit bestand mag gewoon
met git mee.

Gebruik voor productie-runs een **apart** service principal / warehouse dan
voor CI, zodat een PR nooit per ongeluk productiedata raakt.

## 2. Orchestration - Fabric Data Pipeline

Productie-/geplande runs lopen niet via GitHub Actions maar via een
Fabric-native Data Pipeline, zodat het hele verhaal (ingest + transform) in
Fabric zelf te zien en te monitoren is.

Opzet in de Fabric portal (eenmalig, via de UI):

1. **Notebook importeren**: importeer `orchestration/fabric_dbt_run.ipynb`
   als notebook in de workspace. Pas de parameters bovenin aan
   (`git_repo_url`, `key_vault_url`, `target_schema`).
2. **Key Vault koppelen**: zet de 5 secrets uit de tabel hierboven (zelfde
   namen, kebab-case: `fabric-server`, `fabric-database`, `fabric-client-id`,
   `fabric-client-secret`, `fabric-tenant-id`) in een Azure Key Vault, en geef
   de Fabric-workspace identity leesrechten op die vault.
3. **Data Pipeline aanmaken** met:
   - Een **Copy data**-activiteit (of meerdere) die bronbestanden naar
     `Files/landing/<bron>/` in de Lakehouse kopieert.
   - Een **Notebook-activiteit** die naar de geïmporteerde
     `fabric_dbt_run` notebook wijst, na de copy-activiteit(en).
   - Een **Schedule trigger** (bv. dagelijks 06:00) op de pipeline.
   - Optioneel: een failure-notificatie (Teams/e-mail-activiteit) na de
     Notebook-activiteit, alleen bij falen.
4. **Lakehouse -> Warehouse**: geen actie nodig - Fabric's cross-database
   querying laat het Warehouse `dbt_raw` rechtstreeks bij de Lakehouse-tabellen
   in `Landing_bron_data.dbo.*` zolang beide in dezelfde workspace staan
   (zie `models/staging/_sources.yml`).

## 3. Van demo naar live

Om dit project echt tegen een klant-Fabric-omgeving te laten draaien:

1. Vraag/maak een service principal met rechten op het Fabric-warehouse.
2. Vul `~/.dbt/profiles.yml` lokaal in (zie hoofd-README) voor handmatig werk.
3. Zet de 5 GitHub Secrets voor CI.
4. Doorloop de Fabric-portalstappen hierboven voor de Data Pipeline.
5. Bouw de staging-modellen op `source('raw', ...)` (zie
   `models/staging/_sources.yml`) in plaats van de seed-tabellen.
