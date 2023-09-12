variable "resource_group_name" {
  description = "The name of the resource group in wich all resources will be created"
}

variable "location" {
  description = "The location of the resource"
}

variable "name" {
  description = "The name of the resource"
}

variable "retention_days" {
  description = "The number of days the logs are retained"
}

variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module"
}