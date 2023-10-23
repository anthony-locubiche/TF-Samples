variable "resource_group_name" {
  type    = string
}

variable "name" {
  type    = string
}

variable "location" {
  type    = string
}

variable "account_kind" {
  type    = string
}

variable "account_tier" {
  type    = string
}

variable "account_replication_type" {
  type    = string
}

variable "access_tier" {
  type    = string
}

variable "is_hns_enabled" {
  type    = string
}

variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type    = string
  default = true
}

variable "tags" {
description = "A map of the tags to use on the resources that are deployed with this module"
}

variable "virtual_network_subnet_ids" {
  type = list(string)
  default = []
}

variable "ip_rules" {
  type = list(string)
  default = []
}

#variable "log_analytics_workspace_name" {
#  type    = string
#}
#
#variable "log_analytics_workspace_id" {
#  type    = string
#}