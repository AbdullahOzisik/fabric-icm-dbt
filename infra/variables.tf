variable "fabric_client_id" {
  description = "Client ID van de service principal (App registration) die Terraform gebruikt om Fabric aan te sturen."
  type        = string
  sensitive   = true
}

variable "fabric_client_secret" {
  description = "Client secret van de service principal."
  type        = string
  sensitive   = true
}

variable "fabric_tenant_id" {
  description = "Entra ID tenant id."
  type        = string
  sensitive   = true
}

variable "capacity_name" {
  description = "Naam van de bestaande Fabric-capacity waar de workspaces aan gekoppeld worden. Wordt opgezocht via een data source, niet door Terraform aangemaakt (capacity-inkoop is een apart Azure-kostenbesluit)."
  type        = string
}

variable "environments" {
  description = "Eén workspace per omgeving. Key = omgevingsnaam (dev/test/prod), value = weergavenaam van de workspace in Fabric."
  type        = map(string)
  default = {
    dev  = "fabric-icm-dbt-dev"
    test = "fabric-icm-dbt-test"
    prod = "fabric-icm-dbt-prod"
  }
}

variable "workspace_admin_principal_ids" {
  description = "Object-id's (Entra ID) die als Admin aan elke workspace toegevoegd worden, bv. je eigen gebruiker en de service principal voor CI/CD."
  type        = list(string)
  default     = []
}
