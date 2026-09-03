# Bestaande Fabric-capacity opzoeken (wordt niet door Terraform beheerd -
# capacity is een apart Azure-resource/kostenbesluit, zie azurerm_fabric_capacity
# als je die ook via IaC wil provisionen).
data "fabric_capacity" "this" {
  display_name = var.capacity_name
}

# Eén workspace per omgeving (dev/test/prod), zie variables.tf.
resource "fabric_workspace" "this" {
  for_each = var.environments

  display_name = each.value
  description  = "fabric-icm-dbt (${each.key}) - beheerd via Terraform, zie infra/"
  capacity_id  = data.fabric_capacity.this.id
}

resource "fabric_workspace_role_assignment" "admins" {
  for_each = {
    for pair in flatten([
      for env, ws in fabric_workspace.this : [
        for principal_id in var.workspace_admin_principal_ids : {
          key          = "${env}-${principal_id}"
          workspace_id = ws.id
          principal_id = principal_id
        }
      ]
    ]) : pair.key => pair
  }

  workspace_id = each.value.workspace_id
  principal = {
    id   = each.value.principal_id
    type = "User"
  }
  role = "Admin"
}

# Landingszone-Lakehouse per omgeving.
resource "fabric_lakehouse" "landing" {
  for_each = fabric_workspace.this

  workspace_id = each.value.id
  display_name = "Landing_bron_data"
  description  = "Landingszone voor brondata (CSV -> Delta), zie ../orchestration/csv_to_delta.ipynb en copy_into_dbt_raw.sql."
}

# Warehouse waar dbt op verbindt.
resource "fabric_warehouse" "dbt_raw" {
  for_each = fabric_workspace.this

  workspace_id = each.value.id
  display_name = "dbt_raw"
  description  = "Warehouse waar dbt (fabric_icm_dbt project) staging/marts in bouwt."
}
