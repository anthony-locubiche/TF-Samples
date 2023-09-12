variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "purge_protection_enabled" {
  type    = string
  default = true
}

variable "soft_delete_retention_days" {
  type    = string
  default = 90
}
variable "tenant_id" {
  type = string
}

variable "virtual_network_subnet_ids" {
  type = list(any)
}

variable "ip_rules" {
  type = list(any)
}

variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module"
}

variable "access_policy_spn" {
  type = map(object({
    SPN                     = string
    key_permissions         = optional(list(any))
    secret_permissions      = optional(list(any))
    certificate_permissions = optional(list(any))
  }))
  default = {}
}

variable "access_policy_group" {
  type = map(object({
    group                   = string
    key_permissions         = optional(list(any))
    secret_permissions      = optional(list(any))
    certificate_permissions = optional(list(any))
  }))
  default = {}
}