######################################################### GENERAL ##############################################################
variable "location" {
  type    = string
  default = "westeurope"
}
variable "default_tags" {
  description = "List of default tags to be created"
  type        = map
  default     = null
}
######################################################### DATABRICKS ###########################################################
variable "dbricks_workspace_name" {
  description = "Databricks Workspace Name"
  type        = string
}
variable "rg_name" {
  description = "The name of the Resource Group in which the Databricks Workspace should exist"
  type        = string
}
variable "dbricks_managed_rg_name" {
  description = "Databricks Managed Resource Group Name"
  type        = string
  default     = ""
}
variable "sku" {
  type = string
  default = "premium"
}

######################################################### DATABRICKS NETWORK ###################################################
variable dbricks_virtual_network_id {
  description = "Databricks VNet id"
  type        = string
}
variable dbricks_public_subnet_name {
  description = "Databricks public subnet name"
  type        = string
}
variable "dbricks_public_nsg_name" {
  type = string
}
variable "dbricks_public_nsg_subnet_id" {
  type = string
}
variable dbricks_private_subnet_name {
  description = "Databricks private subnet name"
  type        = string
}
variable "dbricks_private_nsg_name" {
  type = string
}
variable "dbricks_private_nsg_subnet_id" {
  type = string
}
######################################################### MONITOR DIAGNOSTIC SETTINGS ##########################################
variable databricks_mds_name {
  type    = string
  default = ""
}
variable storage_account_id {
  type    = string
  default = null
}
variable log_analytics_workspace_id {
  type    = string
  default = null
}

######################################################### DATABRICKS ALLOWED LIST ##############################################
variable "no_public_ip" {
  type = bool
  default = true
}

variable databricks_ip {
  description = "Specifies the list of IP to allow or block"
  type = map(object({
    enableIpAccessLists = bool,
    list_type           = string,
    ip_addresses        = list(string),
    label               = string,
    enabled             = bool
  }))
}