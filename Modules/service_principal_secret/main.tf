resource "time_rotating" "rotation_period" {
  rotation_months = 1
}

resource "azuread_service_principal_password" "spn_secret"{
service_principal_id = data.azuread_service_principal.service_principal.id
   rotate_when_changed = {
    rotation = time_rotating.rotation_period.id
  }
}
