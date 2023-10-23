locals {

  _storage_accounts_applications = try(flatten([
    for app_key, app in local.applications : [
      for storage_account_key, storage_account in app.storage_account : {
        app_key                   = app_key
        storage_account_key       = storage_account_key
        name                      = storage_account.name
        sku_tier                  = storage_account.sku_tier
        replication_type          = storage_account.replication_type
        is_datalake               = storage_account.is_datalake
        access_tier               = storage_account.access_tier
        account_kind              = storage_account.account_kind
        min_tls_version           = storage_account.min_tls_version
        account_tier              = storage_account.account_tier
        is_hns_enabled            = storage_account.is_hns_enabled
        enable_https_traffic_only = storage_account.enable_https_traffic_only
        container                 = storage_account.container
      }
    ]
  ]))

  storage_accounts = {
    for obj in local._storage_accounts_applications : "${obj.app_key}.${obj.storage_account_key}" => obj
  }

  _storage_account_containers = try(flatten([
    for storage_account_key, storage_account in local.storage_accounts : [
      for container_key, container in storage_account.container : {
        storage_account_key = storage_account_key
        container_key       = container_key
        name                = container.name
        access_type         = container.access_type
      }
    ]
  ]))

  storage_account_containers = {
    for obj in local._storage_account_containers : "${obj.storage_account_key}.${obj.container_key}" => obj
  }

  _spn_access_storage_container = flatten([
    for storage_account_key, storage_account in local.storage_accounts : [
      for container_key, container in storage_account.container : [
        for spn_key, spn in((container.permission_spn == null) ? {} : (container.permission_spn)) : {
          storage_account_key = storage_account_key
          container_key       = "${storage_account_key}.${container_key}"
          spn_key             = spn_key
          containerName       = container.name
          access_type         = container.access_type
          role                = spn.role
          spn                 = spn.SPN
        }
      ]
    ]
  ])

  spn_access_storage_container = {
    for obj in local._spn_access_storage_container : "${obj.container_key}.${obj.spn_key}" => obj
  }

  _group_access_storage_container = flatten([
    for storage_account_key, storage_account in local.storage_accounts : [
      for container_key, container in storage_account.container : [
        for group_key, group in((container.permission_group == null) ? {} : (container.permission_group)) : {
          storage_account_key = storage_account_key
          container_key       = "${storage_account_key}.${container_key}"
          group_key           = group_key
          containerName       = container.name
          access_type         = container.access_type
          role                = group.role
          group               = group.GROUP
        }
      ]
    ]
  ])

  group_access_storage_container = {
    for obj in local._group_access_storage_container : "${obj.container_key}.${obj.group_key}" => obj
  }
}

module "datalake_storage" {
  source   = "./Modules/storage/account"
  for_each = try(local.storage_accounts, null)

  name                         = lower("${var.infra_prefix.storage.storage_account}${each.value.name}${var.environment}")
  resource_group_name          = azurerm_resource_group.rg[each.value.app_key].name
  location                     = azurerm_resource_group.rg[each.value.app_key].location
  account_kind                 = each.value.account_kind
  account_tier                 = each.value.account_tier
  account_replication_type     = each.value.replication_type
  access_tier                  = each.value.access_tier
  is_hns_enabled               = each.value.is_hns_enabled
  min_tls_version              = each.value.min_tls_version
  enable_https_traffic_only    = each.value.enable_https_traffic_only
  tags                         = merge({ "App-Name" = format("%s", upper(each.value.app_key)) }, var.tags.common)
#  log_analytics_workspace_id   = module.loganalytics.id
#  log_analytics_workspace_name = module.loganalytics.name
  ip_rules                     = ["195.68.24.242"]
#  depends_on = [
#    module.loganalytics
#  ]
}

#DATALAKE ENDPOINT
#module "datalake_endpoint_dfs" {
#  source   = "Modules/endpoint"
#  for_each = try(local.storage_accounts, null)
#
#  name                           = lower("${var.infra_prefix.networking.private_end_point}${module.datalake_storage[each.key].name}-dfs")
#  location                       = var.location
#  resource_group_name            = azurerm_resource_group.rg[each.value.app_key].name
#  subnet_id                      = data.azurerm_subnet.subnets["Storage_1"].id
#  tags                           = merge({ "ST-App-Name" = format("MDA %s", upper(each.value.app_key)) }, var.tags.common)
#  service_name                   = lower("${var.infra_prefix.networking.service_connection}${var.infra_prefix.storage.storage_account}-${var.location}-${var.environment}-dfs")
#  private_connection_resource_id = module.datalake_storage[each.key].id
#  subresource_names              = ["dfs"]
#  depends_on = [
#    module.datalake_storage
#  ]
#}

#module "datalake_endpoint_blob" {
#  source   = "Modules/endpoint"
#  for_each = try(local.storage_accounts, null)
#
#  name                           = lower("${var.infra_prefix.networking.private_end_point}${module.datalake_storage[each.key].name}-blob")
#  location                       = var.location
#  resource_group_name            = azurerm_resource_group.rg[each.value.app_key].name
#  subnet_id                      = data.azurerm_subnet.subnets["Storage_1"].id
#  tags                           = merge({ "ST-App-Name" = format("MDA %s", upper(each.value.app_key)) }, var.tags.common)
#  service_name                   = lower("${var.infra_prefix.networking.service_connection}${var.infra_prefix.storage.storage_account}-${var.location}-${var.environment}-blob")
#  private_connection_resource_id = module.datalake_storage[each.key].id
#  subresource_names              = ["blob"]
#  depends_on = [
#    module.datalake_storage
#  ]
#}

#DATALAKE CONTAINER
resource "azurerm_storage_container" "container_datalake" {
  for_each = try(local.storage_account_containers, null)

  name                  = "${each.value.name}-00-${var.environment}"
  storage_account_name  = module.datalake_storage[each.value.storage_account_key].name
  container_access_type = "private"
  depends_on = [
    module.datalake_storage
  ]
}

module "permission_spn_access_datalake" {
  for_each = try(local.spn_access_storage_container, null)
  source   = "./Modules/Permission"

  scope                = azurerm_storage_container.container_datalake[each.value.container_key].resource_manager_id
  role_definition_name = each.value.role
  spn_list             = each.value.spn
  depends_on = [
    azurerm_storage_container.container_datalake
  ]
}

module "permission_group_access_datalake" {
  for_each = local.group_access_storage_container
  source   = "./Modules/Permission"

  scope                = azurerm_storage_container.container_datalake[each.value.container_key].resource_manager_id
  role_definition_name = each.value.role
  group_list           = each.value.group
  depends_on = [
    azurerm_storage_container.container_datalake
  ]
}

#resource "azurerm_role_assignment" "set_user_azure_role" {
#  for_each = try(local.storage_accounts, null)
#  scope                = module.datalake_storage[each.key].id
#  role_definition_name = "Storage Account Contributor"
#  principal_id         = "b99bd2ac-8850-4812-bec0-4ae63c47f275" #My User ObjectID to replace with Datasource
#  depends_on = [
#    module.datalake_storage
#  ]
#}

#ACL
module "permission_user_access_administrator_datalake" {
  for_each = try(local.storage_accounts, null)
  source   = "./Modules/Permission"

  scope                = module.datalake_storage[each.key].id
  role_definition_name = "User Access Administrator"
  group_list           = var.azure_admin_groups
  depends_on = [
    module.datalake_storage
  ]
}