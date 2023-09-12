
resource "azurerm_eventhub" "eventhub" {
  name                = var.name
  namespace_name      = var.namespace_name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_authorization_rule" "permission" {
  for_each = try(var.permission, null)

  name                = each.key
  namespace_name      = var.namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

resource "azurerm_key_vault_secret" "connection_string" {
  for_each = azurerm_eventhub_authorization_rule.permission
  key_vault_id = var.key_vault_id
  name  = "eventhub-${azurerm_eventhub.eventhub.name}-${azurerm_eventhub_authorization_rule.permission[each.key].primary_connection_string_alias}"
  value = azurerm_eventhub_authorization_rule.permission[each.key].primary_connection_string
}