locals {
  pre_applications = merge({ platform = var.platform }, var.applications)

  _applications = flatten([
    for app_key, app in local.pre_applications : {
      app_key     = app_key
      storage_account = app.storage_account
      keyvault        = app.keyvault
    }
  ])

  applications = {
    for obj in local._applications : obj.app_key => obj
  }
}