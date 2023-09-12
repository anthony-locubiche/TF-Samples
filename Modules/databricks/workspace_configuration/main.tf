terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.4.8"
    }
  }
}
#
##provider "databricks" {
##  azure_workspace_resource_id = var.workspace_id
##}
#
#Assign users from given groups
resource "databricks_user" "users" {
  for_each  = toset(local.users_object_id)
    user_name = data.azuread_user.users[each.value].mail
}

resource "databricks_group_member" "i-am-user" {
  for_each = toset(local.users_object_id)
    group_id  = data.databricks_group.group.id
    member_id = databricks_user.users[each.value].id
}
##Debug
##TO TEST WITH ANTHONY FOR SECURITY PURPOSE
##resource "databricks_workspace_conf" "databricks_conf" {
##  custom_config = {
##    "enableIpAccessLists" : true
##  }
##}
#
##resource "databricks_ip_access_list" "allowed-list" {
##  label     = "allow_in"
##  list_type = "ALLOW"
##  ip_addresses = ["82.64.0.139", "88.121.169.135", "164.129.115.77", "164.129.1.41", "138.198.100.42", "138.168.100.41", "167.4.1.41", "51.145.225.25", "164.129.115.76", "167.4.1.42", "164.129.1.42", "165.255.202.0/23", "165.225.86.0/23", "165.225.76.0/23", "165.225.94.0/23", "165.225.200.0/23", "82.123.45.163", "165.225.20.0/24"]
##  depends_on = [databricks_workspace_conf.this]
##}