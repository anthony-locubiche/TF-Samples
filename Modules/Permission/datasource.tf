

data "azuread_service_principal" "permission_spn" {
  for_each = toset(var.spn_list)

  display_name = each.key
}

data "azuread_group" "permission_group" {
  for_each = toset(var.group_list)

  display_name = each.key
}