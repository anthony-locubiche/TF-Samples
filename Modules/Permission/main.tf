


resource "azurerm_role_assignment" "set_group_azure_role" {
  for_each = try(toset(var.group_list))

  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = data.azuread_group.permission_group[each.key].id
}

resource "azurerm_role_assignment" "set_spn_azure_role" {
  for_each = try(toset(var.spn_list))

  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = data.azuread_service_principal.permission_spn[each.key].id
}
