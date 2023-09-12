data "azuread_service_principal" "access_policy_spn" {
  for_each     = try(var.access_policy_spn, null)
  display_name = each.value.SPN
}

data "azuread_group" "access_policy_group" {
  for_each     = try(var.access_policy_group, null)
  display_name = each.value.group
}


data "azuread_user" "users" {
  for_each  = local.users
  object_id = each.value.user_object_id
}

data "azurerm_client_config" "current" {}