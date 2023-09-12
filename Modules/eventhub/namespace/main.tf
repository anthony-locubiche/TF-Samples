resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = var.sku
  capacity                 = var.capacity
  auto_inflate_enabled     = true
  maximum_throughput_units = var.maximum_throughput_units
  dedicated_cluster_id     = var.dedicated_cluster_id
  tags                     = var.tags
  network_rulesets = [{
    default_action                 = "Deny"
    trusted_service_access_enabled = "true"
    ip_rule                        = var.ip_rules
    virtual_network_rule           = var.virtual_network_rule
  }]
}
