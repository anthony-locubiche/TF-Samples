data "azurerm_client_config" "current" {}


data "azurerm_subscription" "current" {
}

#data "azurerm_resource_group" "rg-mda" {
#  name = "${var.infra_prefix.general.resource_group}${data.azurerm_subscription.current.display_name}-mda"
#}
data "azurerm_subnet" "subnets" {
  for_each = local.subnets

  name                 = each.value.subnetSurname
  virtual_network_name = each.value.networkSurname
  resource_group_name  = azurerm_resource_group.rg["platform"].name
  depends_on = [azurerm_virtual_network.platform_vnet]
}