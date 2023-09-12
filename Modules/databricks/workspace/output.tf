output "id" {
  value = azurerm_databricks_workspace.databricks-workspace.workspace_id
}

output "name" {
  value = azurerm_databricks_workspace.databricks-workspace.name
}

output "url" {
  value = azurerm_databricks_workspace.databricks-workspace.workspace_url
}
output "resource_group_name" {
  value = azurerm_resource_group.rg-databricks.name
}