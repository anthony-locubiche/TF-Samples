data "databricks_group" "admins_group" {
  display_name = "admins"
}

data "databricks_group" "users_group" {
  display_name = "users"
}

data "azuread_user" "all_users" {
  for_each = toset(distinct(concat(local.admin_users_object_id, local.users_object_id))) #Concatenate AAD groups to get all users
  object_id = each.value
  depends_on = [data.azuread_group.user_groups,data.azuread_group.admin_groups]
}

#Admin members - The Object IDs of the Admin Group members.
data "azuread_group" "admin_groups" {
  for_each = toset(var.databricks_admin_AAD_groups)
  display_name     = each.value
}

#User members - The Object IDs of the User Group members.
data "azuread_group" "user_groups" {
  for_each = toset(var.databricks_user_AAD_groups)
  display_name     = each.value
}

# Mount storage account container that requires SPN credentials stored in KeyVault
data "azurerm_key_vault" "key_vault_for_storage_account" {
  for_each = var.dbricks_adls_gen2_mount
  name = each.value.keyvault_name
  resource_group_name = each.value.keyvault_rg
}

data "azurerm_key_vault_secret" "kv_secret_app_id_for_storage_account" {
  for_each = var.dbricks_adls_gen2_mount
  name      = each.value.kv_secret_app_id_name
  key_vault_id = data.azurerm_key_vault.key_vault_for_storage_account[each.key].id
}