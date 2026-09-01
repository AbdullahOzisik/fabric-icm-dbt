# fabric-icm-dbt

dbt-project voor ICM op Microsoft Fabric (Fabric Warehouse / Synapse Data Warehouse), met de `dbt-fabric` adapter.

## Setup

1. Virtuele omgeving aanmaken en activeren:

   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   ```

2. Dependencies installeren:

   ```powershell
   pip install -r requirements.txt
   ```

3. Profiel instellen: kopieer `profiles.yml.example` naar `~/.dbt/profiles.yml` en vul je Fabric-omgeving in (server, database, authenticatie).

4. Packages installeren (bv. dbt_utils):

   ```powershell
   dbt deps
   ```

5. Verbinding testen:

   ```powershell
   dbt debug
   ```

## Projectstructuur

- `models/staging` — 1-op-1 modellen op de brontabellen (views)
- `models/marts` — business/aggregatiemodellen (tables)
- `seeds` — statische CSV-brondata
- `snapshots` — SCD Type 2 snapshots
- `macros` — herbruikbare Jinja-macro's
- `analyses` — losse analyse-SQL (niet gematerialiseerd)
- `tests` — custom (singular) data tests

## Adapter

Dit project gebruikt [`dbt-fabric`](https://github.com/microsoft/dbt-fabric), de officiële Microsoft-adapter voor Microsoft Fabric Data Warehouse / Azure Synapse Data Warehouse. dbt-core en dbt-fabric zijn beide gratis en open source.

## CI/CD & orchestration

- **CI**: `.github/workflows/ci.yml` (GitHub Actions) - draait `dbt parse` op elke PR, en `dbt seed` + `dbt build` tegen een dev/test Fabric warehouse zodra de `FABRIC_*` secrets in GitHub Secrets staan.
- **Orchestration**: productie-/geplande runs lopen via een Fabric Data Pipeline (Notebook-activiteit + schedule trigger), niet via GitHub Actions.
- **Datalake-ingest**: bronbestanden landen in een Fabric Lakehouse en komen via een OneLake shortcut als `raw`-schema het Warehouse binnen, waar dbt op leest.

Volledige opzetstappen (Key Vault, service principal, pipeline, shortcuts) staan in [`orchestration/README.md`](orchestration/README.md).
