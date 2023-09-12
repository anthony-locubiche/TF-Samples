output "id" {
  value = azurerm_storage_account.datalake_storage.id
}

output "name" {
  value = azurerm_storage_account.datalake_storage.name
}

output "object_id" {
  value = azurerm_storage_account.datalake_storage.identity.0.principal_id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.datalake_storage.primary_blob_endpoint
}

output "primary_access_key" {
  value = azurerm_storage_account.datalake_storage.primary_access_key
}
