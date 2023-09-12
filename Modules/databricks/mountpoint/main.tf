terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

resource "databricks_azure_adls_gen2_mount" "data_mount_datalake" {
  provider = databricks
  container_name         = var.container_name
  storage_account_name   = var.storage_account_name
  mount_name             = var.mountpoint_name
  tenant_id              = var.tenant_id
  client_id              = var.client_id
  client_secret_scope    = var.client_secret_scope
  client_secret_key      = var.client_secret_key
  initialize_file_system = var.initialize_file_system
}