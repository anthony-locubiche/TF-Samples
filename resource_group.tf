resource "azurerm_resource_group" "rg" {
  for_each = local.applications
  name     = lower("${var.infra_prefix.general.resource_group}${var.environment}-${each.key}")
  location = var.location
  tags     = merge({ "App-Name" = format("%s", upper(each.key)) }, var.tags.common)
}
