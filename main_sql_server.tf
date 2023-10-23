
# resource "time_rotating" "sql_admin_password_rotation_period" {
#   rotation_months = 6
# }


# output "test" {
#   value = time_rotating.sql_admin_password_rotation_period.id
# }

resource "random_password" "password_sql_server_platform" {
  length           = 24
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  special          = true
  override_special = "_%-!"
  # keepers = {
  #   rotation = time_rotating.sql_admin_password_rotation_period.id
  # }
}

resource "azurerm_key_vault_secret" "secret_sql_server_platform" {
  name         = "sql-server-secret"
  value        = random_password.password_sql_server_platform.result
  key_vault_id = module.keyvault["platform"].id
  depends_on = [module.keyvault]
}

#module "sqlserver_platform" {
#  source   = "./Modules/sql/server"
#
#  name                         = lower("${var.infra_prefix.databases.azure_sql_server}${var.infra_prefix.general.app_name}-${var.environment}")
#  resource_group_name          = azurerm_resource_group.rg["platform"].name
#  location                     = azurerm_resource_group.rg["platform"].location
#  server_version               = var.platform.sql_server.server_version #each.value.server_version
#  administrator_login          = var.platform.sql_server.administrator_login #each.value.administrator_login
#  administrator_login_password = azurerm_key_vault_secret.secret_sql_server_platform.value
#  subnet_id                    = data.azurerm_subnet.subnets["vnet-access"].id
#  tags                         = merge({ "App-Name" = format("%s", upper("COMMON")) }, var.tags.common)
#  #storage_endpoint             = module.datalake_storage["platform"].primary_blob_endpoint
#  #storage_account_access_key   = module.datalake_storage["platform"].primary_access_key
#  #sql_tde_key                  = "sql-tde-key"
#  #virtual_network_subnet_ids   = local.sql_authorized_network
#  virtual_network_subnet_ids   = local.test
#
#  depends_on = [
#    azurerm_key_vault_secret.secret_sql_server_platform
#  ]
#}
#
#module "endpoint_sql_server_platform" {
#  source = "./Modules/endpoint"
#
#  name                           = lower("privateendpoint-${var.infra_prefix.databases.azure_sql_server}01-${var.infra_prefix.general.app_name}")
#  location                       = var.location
#  resource_group_name            = module.sqlserver_platform.resource_group_name #data.azurerm_resource_group.rg-private_endpoint.name
#  subnet_id                      = data.azurerm_subnet.subnets["Access_subnet1"].id
#  tags                           = merge({ "App-Name" = format("%s", upper("COMMON")) }, var.tags.common)
#  service_name                   = lower("privateserviceconnection-${var.infra_prefix.databases.azure_sql_server}01-${var.infra_prefix.general.app_name}")
#  private_connection_resource_id = module.sqlserver_platform.id
#  subresource_names              = ["sqlServer"]
#  depends_on = [module.sqlserver_platform]
#}

