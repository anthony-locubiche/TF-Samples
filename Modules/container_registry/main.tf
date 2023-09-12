resource "azurerm_container_registry" "container_registry" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  sku                       = var.sku
  tags                      = var.tags
  #public_network_access_enabled = false
}

# network_rule_set {
#     default_action          = "Deny"
#     # ip_rule                 = var.ip_rule
#     # virtual_network         = var.virtual_network
#   }
