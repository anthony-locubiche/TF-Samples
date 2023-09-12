#https://www.terraform.io/docs/providers/azurerm/r/function_app.html
#https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html


locals {
  global_settings = merge(var.global_app_settings, var.function_app_settings, {APPINSIGHTS_INSTRUMENTATIONKEY = var.APPINSIGHTS_INSTRUMENTATIONKEY}, {KEYVAULTURI = var.KEYVAULTURI}, {TENANT_ID = var.TENANT_ID})
}

resource "azurerm_function_app" "function" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only                 = true
  os_type                    = var.os_type
  version                    = "~3"
  tags                       = var.tags

  app_settings = local.global_settings

  identity {
    type = "SystemAssigned"
  }

# app_settings = {
#   "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_instrumentation_key
#   "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
#   "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
# }

  site_config {
    pre_warmed_instance_count = 2
    linux_fx_version          = "PYTHON|3.8"
    use_32_bit_worker_process = false
    ftps_state                 = "FtpsOnly"
  }

   lifecycle {
     ignore_changes = [
       app_settings["WEBSITE_RUN_FROM_PACKAGE"],
       site_config["scm_type"],
       source_control,
     ]
   }
}

#   dynamic "identity" {
#     for_each = var.managed_identity == "" ? [1] : []
#     content{
#       type = "SystemAssigned"
#     }
#   }

#   dynamic "identity" {
#     for_each = var.managed_identity == "" ? [] : [1]
#     content{
#       type = "UserAssigned"
#       identity_ids = [var.managed_identity]
#     }
#   }

#   version = "~3"
#   tags                      = var.tags

#   lifecycle {
#     ignore_changes = [
#       app_settings["WEBSITE_RUN_FROM_PACKAGE"],
#       site_config["scm_type"],
#       source_control,
#     ]
#   }


data "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name                       = "SendToLogAnalytics"
  target_resource_id         = azurerm_function_app.function.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id

  log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
