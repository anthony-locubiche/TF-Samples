#EVENTHUB


variable "name" {
  type    = string
}

variable "location" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "sku" {
  type    = string
}

variable "capacity" {
  type    = number
}

variable "maximum_throughput_units" {
  type    = string
}

variable "dedicated_cluster_id" {
  type    = string
}

variable "tags" {
description = "A map of the tags to use on the resources that are deployed with this module"
}

variable "virtual_network_rule" {
type = list(any)

}

variable "ip_rules" {
  type    = list(any)
}

