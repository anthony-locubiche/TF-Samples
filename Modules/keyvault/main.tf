terraform {
}


locals {
  _users = flatten([
    for group_key, group in data.azuread_group.access_policy_group : [
      for users in group.members : {
        group_key      = group_key
        user_object_id = users
      }
    ]
  ])
  users = {
    for obj in local._users : "${obj.group_key}.${obj.user_object_id}" => obj
  }
}

resource "azurerm_key_vault" "keyvault" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = var.tags


  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }
}

resource "azurerm_key_vault_access_policy" "terraform_account" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  key_permissions         = ["Get", "Create", "Delete", "List", "Restore", "Recover", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  secret_permissions      = ["Get", "Set", "List", "Delete", "Recover"]
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]

  depends_on = [
    azurerm_key_vault.keyvault
  ]
}

#resource "azurerm_key_vault_access_policy" "SPN" {
#  for_each = var.access_policy_spn
#
#  key_vault_id            = azurerm_key_vault.keyvault.id
#  tenant_id               = data.azurerm_client_config.current.tenant_id
#  object_id               = data.azuread_service_principal.access_policy_spn[each.key].object_id
#  key_permissions         = each.value.key_permissions
#  secret_permissions      = each.value.secret_permissions
#  certificate_permissions = each.value.certificate_permissions
#
#  depends_on = [
#    azurerm_key_vault.keyvault
#  ]
#}

#resource "azurerm_key_vault_access_policy" "group" {
#  for_each = try(local.users, null)
#
#  key_vault_id            = azurerm_key_vault.keyvault.id
#  tenant_id               = data.azurerm_client_config.current.tenant_id
#  object_id               = each.value.user_object_id
#  key_permissions         = var.access_policy_group[each.value.group_key].key_permissions
#  secret_permissions      = var.access_policy_group[each.value.group_key].secret_permissions
#  certificate_permissions = var.access_policy_group[each.value.group_key].certificate_permissions
#
#  depends_on = [
#    azurerm_key_vault.keyvault
#  ]
#}

# resource "random_password" "password_sql_server" {
#   length           = 24
#   min_numeric      = 1
#   min_lower        = 1
#   min_upper        = 1
#   min_special      = 1
#   special          = true
#   override_special = "_%!"
# }

# resource "random_password" "password_sql_server_tibco" {
#   length           = 24
#   min_numeric      = 1
#   min_lower        = 1
#   min_upper        = 1
#   min_special      = 1
#   special          = true
#   override_special = "_%!"
# }

# resource "azurerm_key_vault_secret" "secret_sql_server" {
#   name         = "secret-sql-server"
#   value        = random_password.password_sql_server.result
#   key_vault_id = azurerm_key_vault.keyvault.id
#     depends_on = [
#     azurerm_key_vault_access_policy.client,
#     azurerm_key_vault_access_policy.storage
#   ]
# }

# resource "azurerm_key_vault_secret" "secret_sql_server_tibco" {
#   name         = "secret-sql-server-tibco"
#   value        = random_password.password_sql_server_tibco.result
#   key_vault_id = azurerm_key_vault.keyvault.id
#     depends_on = [
#     azurerm_key_vault_access_policy.client,
#     azurerm_key_vault_access_policy.storage
#   ]
# }