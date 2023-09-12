terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

resource "databricks_cluster" "cluster" {
  provider = databricks
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  driver_node_type_id     = var.driver_node_type_id
  instance_pool_id        = var.instance_pool_id
  autotermination_minutes = var.autotermination_minutes
  num_workers             = var.num_workers #When 0 (for SingleNode) then autoscale block is skipped
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
  custom_tags             = var.custom_tags

  dynamic "init_scripts" {
    #Create a init_scripts { dbfs { destination = xxx }} block foreach "key" of init_scripts defined in env_*.tfs
    for_each = [
      for i in var.init_scripts : {
        destination = i.destination
      }
    ]
    content {
      dbfs {
        destination = init_scripts.value.destination
      }
    }
  }
}

resource "databricks_permissions" "cluster_permissions" {
  provider = databricks
  cluster_id = databricks_cluster.cluster.id
  #Create as many 'access_control' blocks as there are in var.access_controls
  dynamic "access_control" {
    for_each = var.access_controls
    content {
      group_name       = access_control.value["group_name"]
      permission_level = access_control.value["permission_level"] #i.e: CAN_ATTACH_TO, CAN_RESTART or CAN_MANAGE
    }
  }

  depends_on = [
    databricks_cluster.cluster
  ]
}
#Comment for the moment because not used yet by developers, if needed then uncomment, you need to pass the azurem as provider
#resource "azurerm_key_vault_secret" "clusters-id" {
#  name          = var.keyvault_secret_name
#  value         = databricks_cluster.cluster.id
#  key_vault_id  = var.keyvault_workspace_id
#
#  depends_on = [
#    databricks_cluster.cluster
#  ]
#}