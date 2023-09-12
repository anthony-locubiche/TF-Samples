############################################### azurerm databricks workspace section ###############################################
output "workspace_name" {
  value       = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].name : ""
}
output "managed_resource_group_id" {
  value = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].managed_resource_group_id : null
}
output "workspace_url" {
  value = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].workspace_url : null
}
output "workspace_id" {
  value = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].workspace_id : null
}
output "id" {
  value = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].id : null
}
output "rg_name" {
  value = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].resource_group_name : null
}