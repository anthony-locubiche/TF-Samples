resource "azurerm_storage_account" "datalake_storage" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  is_hns_enabled            = var.is_hns_enabled
  min_tls_version           = var.min_tls_version
  enable_https_traffic_only = var.enable_https_traffic_only
  tags                      = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account_network_rules" "datalake_storage_network_rules" {
  storage_account_id = azurerm_storage_account.datalake_storage.id
  #DEPRECATED PARAMS
  #storage_account_name = azurerm_storage_account.datalake_storage.name
  #resource_group_name = azurerm_storage_account.datalake_storage.resource_group_name
  default_action             = "Deny"
  bypass                     = ["None"]
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  depends_on = [
    azurerm_storage_account.datalake_storage
  ]
}

#MONITOR DB
module "storage_monitor" {
  source = "../../loganalytics/monitordiagnosticsetting"

  target_resource_name         = azurerm_storage_account.datalake_storage.name
  target_resource_id           = azurerm_storage_account.datalake_storage.id
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_id   = var.log_analytics_workspace_id
}
