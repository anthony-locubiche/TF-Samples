terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

resource "databricks_instance_pool" "pool" {
  provider = databricks
  instance_pool_name                    = var.instance_pool_name
  min_idle_instances                    = var.min_idle_instances
  max_capacity                          = var.max_capacity
  node_type_id                          = var.node_type_id
  idle_instance_autotermination_minutes = var.idle_instance_autotermination_minutes
}

resource "databricks_permissions" "pool_permissions" {
  provider = databricks
  instance_pool_id = databricks_instance_pool.pool.id

  #Create as many 'access_control' blocks as there are in var.access_controls
  dynamic "access_control" {
    for_each = var.access_controls
    content {
      group_name       = access_control.value["group_name"]
      permission_level = access_control.value["permission_level"] #i.e: CAN_ATTACH_TO or CAN_MANAGE
    }
  }

  depends_on = [
    databricks_instance_pool.pool
  ]
}