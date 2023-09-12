
# Private DNS Zone using private endpoints
data "azuread_service_principal" "service_principal" {
  display_name = var.service_principal_name

}

