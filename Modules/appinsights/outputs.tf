output "instrumentation_key" {
    value = azurerm_application_insights.logs.instrumentation_key
}

output "connection_string" {
    value = azurerm_application_insights.logs.connection_string
}

output "id" {
  value = azurerm_application_insights.logs.app_id
}