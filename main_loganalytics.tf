module "loganalytics" {
  source              = "./Modules/loganalytics/loganalyticsworkspace"
  name                = lower("${var.infra_prefix.management_and_governance.log_analytics_workspace}${var.environment}00")
  location            = azurerm_resource_group.rg["platform"].location
  resource_group_name = azurerm_resource_group.rg["platform"].name
  sku                 = var.log_analytics_config.sku
  retention_in_days   = var.log_analytics_config.retention_in_days
  tags                = merge({ "ST-App-Name" = format("%s", upper("COMMON")) }, var.tags.common)
}

#MONITOR LOG ANALYTICS
module "loganalytics_monitor" {
  source = "./Modules/loganalytics/monitordiagnosticsetting"

  target_resource_name = module.loganalytics.name
  target_resource_id   = module.loganalytics.id
  log_categories = ["AuditEvent"]

  log_analytics_workspace_name = module.loganalytics.name
  log_analytics_workspace_id   = module.loganalytics.id
}
