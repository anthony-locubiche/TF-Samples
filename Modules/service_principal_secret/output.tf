output "secret" {
  value =azuread_service_principal_password.spn_secret.value
  }

output "object_id" {
  value =azuread_service_principal_password.spn_secret.key_id
}