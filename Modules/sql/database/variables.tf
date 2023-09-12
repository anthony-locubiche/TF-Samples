#SQL DATABASE

variable "name" {
  type = string
}

variable "sql_server_id" {
  type = string
}

variable "collation" {
  type    = string
  default = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

variable "sku_name" {
  type = string
}

variable "max_size_gb" {
  type = number
  default = null
}

variable "read_scale" {
  type = string
  default = null
}

variable "min_capacity" {
  type = string
  default = null
}

variable "auto_pause_delay_in_minutes" {
  type = string
  default = null
}

variable "zone_redundant" {
  type = bool
  default = null
}

variable "read_replica_count" {
  type = string
  default = null
}

variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module"
  type = map
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}