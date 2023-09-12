resource "azurerm_private_endpoint" "endpoint" {
  name                = var.name
  location            = var.location
  resource_group_name = lower(var.resource_group_name)
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = lower(var.service_name)
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }
}