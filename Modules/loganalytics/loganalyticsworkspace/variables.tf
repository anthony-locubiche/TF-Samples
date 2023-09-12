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

variable "retention_in_days" {
  type    = number
}

variable "tags" {
description = "A map of the tags to use on the resources that are deployed with this module"
}