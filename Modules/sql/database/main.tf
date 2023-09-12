resource "azurerm_mssql_database" "sql_database" {
  name                        = var.name
  server_id                   = var.sql_server_id
  collation                   = var.collation
  sku_name                    = var.sku_name
  max_size_gb                 = var.max_size_gb
  read_scale                  = var.read_scale
  min_capacity                = var.min_capacity
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  zone_redundant              = var.zone_redundant
  read_replica_count          = var.read_replica_count
  tags                        = var.tags

  #
  #  dynamic "threat_detection_policy" {
  #    for_each = var.sql_db_threat_detection_policy
  #    content {
  #      state                                    = threat_detection_policy.value.state
  #      disabled_alerts                          = threat_detection_policy.value.disabled_alerts
  #      email_account_admins                     = threat_detection_policy.value.email_account_admins
  #      email_addresses                          = threat_detection_policy.value.email_addresses
  #      retention_days                           = threat_detection_policy.value.retention_days
  #      storage_account_access_key               = threat_detection_policy.value.storage_account_access_key
  #      storage_endpoint                         = threat_detection_policy.value.storage_endpoint
  #      use_server_default                       = threat_detection_policy.value.use_server_default
  #      }
  #    }
}

#MONITOR DB
module "function_monitor" {
  source = "../../loganalytics/monitordiagnosticsetting"

  target_resource_name         = azurerm_mssql_database.sql_database.name
  target_resource_id           = azurerm_mssql_database.sql_database.id
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_id   = var.log_analytics_workspace_id
}

#LOCK DATABASES
#lock_level - (Required) Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created.
resource "azurerm_management_lock" "lock_delete" {
  name       = "lock_delete_databases"
  scope      = azurerm_mssql_database.sql_database.id
  lock_level = "CanNotDelete"
  notes      = "Databases can't be deleted in this subscription!"
  depends_on = [azurerm_mssql_database.sql_database]
}