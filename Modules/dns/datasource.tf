
locals {
  privatelink_url_suffix = replace(var.dns_suffix,"{region}",var.location)
}

  # Private DNS Zone using private endpoints
data "azurerm_private_dns_zone" "private_dns" {
  name                = local.privatelink_url_suffix
  resource_group_name = var.dns_rg_name
}

