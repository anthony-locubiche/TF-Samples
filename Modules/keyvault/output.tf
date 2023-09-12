output "id" {
  value = azurerm_key_vault.keyvault.id
}

output "name" {
  value = azurerm_key_vault.keyvault.name
}

output "vault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}
# output "key_name" {
#   value = azurerm_key_vault_key.storage_key.name
# }