output "workspace_ids" {
  description = "Workspace-id per omgeving - handig voor de Fabric-portal-URL (app.fabric.microsoft.com/groups/<id>)."
  value       = { for env, ws in fabric_workspace.this : env => ws.id }
}

output "warehouse_ids" {
  description = "Warehouse-id (dbt_raw) per omgeving."
  value       = { for env, wh in fabric_warehouse.dbt_raw : env => wh.id }
}

output "lakehouse_ids" {
  description = "Lakehouse-id (Landing_bron_data) per omgeving."
  value       = { for env, lh in fabric_lakehouse.landing : env => lh.id }
}
