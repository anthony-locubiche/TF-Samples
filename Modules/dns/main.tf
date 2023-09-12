
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}


# Private DNS Zone for Blob setup
resource "azurerm_private_dns_a_record" "private_dns" {
  name                = var.dns_name
  zone_name           = data.azurerm_private_dns_zone.private_dns.name
  resource_group_name = var.dns_rg_name
  ttl                 = 3600
  records             = [var.ip_address]
  // or equivalent, such as:  azurerm_private_endpoint.storage_private_endpoint[*].private_service_connection[0].private_ip_address
  provider            = azurerm
}

