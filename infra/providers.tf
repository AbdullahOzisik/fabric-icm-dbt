# Authenticatie via service principal - zelfde 3 waarden als de GitHub Secrets
# voor CI (FABRIC_CLIENT_ID / FABRIC_CLIENT_SECRET / FABRIC_TENANT_ID), zie
# ../orchestration/README.md. Vereist dat een tenant-admin service principals
# heeft toegestaan voor de Fabric APIs (Fabric admin portal -> Tenant settings
# -> Developer settings -> "Service principals can use Fabric APIs").
provider "fabric" {
  client_id     = var.fabric_client_id
  client_secret = var.fabric_client_secret
  tenant_id     = var.fabric_tenant_id
}
