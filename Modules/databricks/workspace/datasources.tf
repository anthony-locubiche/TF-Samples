#data "databricks_group" "group" {
#  display_name = "admins"
#}
#
##members - The Object IDs of the Group members.
#data "azuread_group" "groups" {
#  for_each = toset(var.AAD_groups)
#  display_name     = each.value
#}
#
#data "azuread_user" "users" {
#  for_each = toset(local.users_object_id)
#  object_id = each.value
#}