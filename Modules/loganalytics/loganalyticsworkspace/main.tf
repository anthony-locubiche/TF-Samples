resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  retention_in_days          = var.retention_in_days
  tags                       = var.tags
  internet_ingestion_enabled = true
  internet_query_enabled     = true
}