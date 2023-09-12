variable "resource_group_name" {
  type    = string
}

variable "name" {
  type    = string
}

variable "location" {
  type    = string
}

#SQL SERVER

variable "server_version" {
    type    = string
}

variable "administrator_login" {
    type    = string
}

variable "administrator_login_password" {
    type    = string
}

variable "subnet_id" {
    type    = string
}


#variable "storage_endpoint" {
#    type    = string
#}
#
#variable "storage_account_access_key" {
#    type    = string
#}
#
#variable "sql_tde_key" {
#    type    = string
#}

variable "tags" {
description = "A map of the tags to use on the resources that are deployed with this module"
}

variable "virtual_network_subnet_ids" {
    type    = map
}

# variable "subnets" {
#   type = map
# }
