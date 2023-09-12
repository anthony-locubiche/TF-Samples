output "id" {
  value = azurerm_function_app.function.id
}

output "principal_id" {
  value = azurerm_function_app.function.identity.0.principal_id
}

output "name" {
  value = azurerm_function_app.function.name
}

output "host_name" {
  value = azurerm_function_app.function.default_hostname
}