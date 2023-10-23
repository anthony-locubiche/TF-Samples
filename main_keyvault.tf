locals {
  _keyvaults = flatten([
    for app_key, app in local.applications : {
      app_key                    = app_key
      sku                        = app.keyvault.sku
      purge_protection_enabled   = app.keyvault.purge_protection_enabled
      soft_delete_retention_days = app.keyvault.soft_delete_retention_days
      access_policy_spn          = app.keyvault.access_policy_spn
      access_policy_group        = app.keyvault.access_policy_group
    }
  ])

  keyvaults = {
    for obj in local._keyvaults : obj.app_key => obj
  }
}

module "keyvault" {
  source   = "./Modules/keyvault"
  for_each = try(local.keyvaults, null)

  name                       = lower("${var.infra_prefix.management_and_governance.azure_key_vault}${var.environment}-${each.value.app_key}")
  location                   = azurerm_resource_group.rg[each.value.app_key].location
  resource_group_name        = azurerm_resource_group.rg[each.value.app_key].name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = each.value.sku
  purge_protection_enabled   = each.value.purge_protection_enabled
  soft_delete_retention_days = each.value.soft_delete_retention_days
  tags                       = merge({ "App-Name" = format("%s", upper(each.value.app_key)) }, var.tags.common)
  ip_rules                   = ["195.68.24.242"] #var.ip_rules
  virtual_network_subnet_ids = [] #local.virtual_network_subnet_ids
  access_policy_spn          = each.value.access_policy_spn
  access_policy_group        = each.value.access_policy_group
}

#module "keyvault_endpoint" {
#  source   = "Modules/endpoint"
#  for_each = try(local.keyvaults, null)
#
#  name                           = lower("${var.infra_prefix.networking.private_end_point}${module.keyvault[each.key].name}")
#  location                       = var.location
#  resource_group_name            = azurerm_resource_group.rg[each.value.app_key].name
#  subnet_id                      = data.azurerm_subnet.subnets["Heading_1"].id
#  tags                           = merge({ "ST-App-Name" = format("MDA %s", upper(each.value.app_key)) }, var.tags.common)
#  service_name                   = lower("${var.infra_prefix.networking.service_connection}${var.infra_prefix.management_and_governance.azure_key_vault}${var.location}-${var.environment}")
#  private_connection_resource_id = module.keyvault[each.key].id
#  subresource_names              = ["vault"]
#  depends_on = [
#    module.keyvault
#  ]
#}

#MONITOR project KEYVAULT
#module "keyvault_monitor" {
#  source   = "./Modules/loganalytics/monitordiagnosticsetting"
#  for_each = try(local.keyvaults, null)
#
#  target_resource_name         = module.keyvault[each.key].name
#  target_resource_id           = module.keyvault[each.key].id
#  log_analytics_workspace_name = module.loganalytics.name
#  log_analytics_workspace_id   = module.loganalytics.id
#  log_categories               = []
#}

