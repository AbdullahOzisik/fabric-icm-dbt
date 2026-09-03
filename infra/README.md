# infra - Fabric-omgeving via Terraform

Provisiont de Fabric-workspaces (dev/test/prod) inclusief de Lakehouse
(`Landing_bron_data`) en het Warehouse (`dbt_raw`) waar het dbt-project
(`../` - zie hoofd-README en `../orchestration/README.md`) op draait.

**Let op - provider is relatief nieuw**: dit gebruikt de officiële
[`microsoft/fabric`](https://registry.terraform.io/providers/microsoft/fabric/latest/docs)
provider. Attribuutnamen/resources kunnen tussen versies veranderen - check
altijd de actuele docs op de Terraform Registry voor je `apply` draait,
zeker als `terraform plan` een resource-schema-fout geeft.

## Vereisten

1. Een **bestaande Fabric-capacity** (F-SKU of trial-capacity) - wordt hier
   opgezocht via een data source, niet aangemaakt. Capacity-inkoop is een
   apart Azure-kostenbesluit; regel dat los (bv. via `azurerm_fabric_capacity`
   als je dat ook als code wil, of gewoon via de Azure portal).
2. Een **service principal** met:
   - Rechten om de capacity toe te wijzen (meestal Contributor op de
     capacity-resource in Azure).
   - Tenant-instelling **"Service principals can use Fabric APIs"** aan (Fabric
     admin portal -> Tenant settings -> Developer settings). Dit vereist
     tenant-adminrechten - dezelfde beperking die we tegenkwamen bij de
     GitHub Actions CI-koppeling, zie `../orchestration/README.md`.
3. Terraform >= 1.7.

## Gebruik

```powershell
cd infra
terraform init

$env:TF_VAR_fabric_client_id     = "<client-id>"
$env:TF_VAR_fabric_client_secret = "<client-secret>"
$env:TF_VAR_fabric_tenant_id     = "<tenant-id>"

cp terraform.tfvars.example terraform.tfvars
# vul capacity_name in terraform.tfvars in

terraform plan
terraform apply
```

## Wat dit wel/niet doet

- **Wel**: workspace + Lakehouse + Warehouse per omgeving aanmaken, met
  rolverdeling.
- **Niet**: de CSV's naar Delta converteren (dat blijft
  `../orchestration/csv_to_delta.ipynb` of `copy_into_dbt_raw.sql`), en niet
  de dbt-modellen bouwen (dat blijft `dbt build` vanuit de projectroot, of de
  Fabric Data Pipeline uit `../orchestration/README.md`).
- Na `terraform apply`: vul `~/.dbt/profiles.yml` (lokaal) of de GitHub
  Secrets (CI) met de server/database van het nieuwe Warehouse - zie de
  outputs (`terraform output warehouse_ids`) en de hoofd-README.

## State

Er is bewust geen remote backend geconfigureerd. Voor een echte
klantomgeving: zet een remote backend (bv. Azure Storage Account) op zodat
`terraform.tfstate` niet lokaal/los rondslingert en het team dezelfde state
deelt.
