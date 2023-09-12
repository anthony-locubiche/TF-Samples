terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

resource "databricks_group_member" "i-am-admin" {
  for_each = toset(jsondecode(file("./${var.group_name}.txt")))

    group_id      = var.group[var.group_name].id
    member_id     = var.members[each.value].id
}