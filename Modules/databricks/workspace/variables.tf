variable "tenant_id" {
  type = string
}
variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type = string
  default = "premium"
}
variable "no_public_ip" {
  type = bool
  default = true
}
variable "virtual_network_id" {
  type = string
}
#Private Subnet
variable "private_subnet_name" {
  type = string
}
#Private NSG
variable "private_nsg_name" {
  type = string
}
variable "private_nsg_subnet_id" {
  type = string
}
#Public subnet
variable "public_subnet_name" {
  type = string
}
#Public NSG
variable "public_nsg_name" {
  type = string
}
variable "public_nsg_subnet_id" {
  type = string
}
#Tags
variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module"
}

#Log Analytics
variable "log_analytics_workspace_name" {
  type = string
}
variable "log_analytics_workspace_id" {
  type = string
}

#variable "AAD_groups" {
#  type = list
#  description = "Authorized AD Groups to the Databricks Workspace"
#}