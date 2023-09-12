data "azurerm_client_config" "current" {}


data "azurerm_subscription" "current" {
}

#data "azurerm_resource_group" "rg-mda" {
#  name = "${var.infra_prefix.general.resource_group}${data.azurerm_subscription.current.display_name}-mda"
#}