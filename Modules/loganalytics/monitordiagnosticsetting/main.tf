data "azurerm_monitor_diagnostic_categories" "logs" {
  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "monitordiagnosticsetting" {
  name                       = "Send ${var.target_resource_name} logs to ${var.log_analytics_workspace_name}"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.logs.metrics
    content {   
      category = metric.key
      enabled  = true
    }
  }
}