output "id" {
  value = azurerm_private_endpoint.endpoint.id
}

output "name" {
  value = azurerm_private_endpoint.endpoint.name
}

output "ipaddress" {
  value = azurerm_private_endpoint.endpoint.private_service_connection[0].private_ip_address
}