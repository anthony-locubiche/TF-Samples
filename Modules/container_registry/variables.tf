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

variable "tags" {
description = "A map of the tags to use on the resources that are deployed with this module"
}

# variable "network_rule_set" {
#   type    = object({
#     default_action  = string
#     ip_rule         = object({
#                       action    = string
#                       ip_range  = string
#                     })
#     virtual_network = object({
#                       action    = string
#                       subnet_id = string
#                     })
#   })
# }

# variable "ip_rule" {
#   type        = set(object({
#     action    = string
#     ip_range  = string
#   }))
# }

# variable "virtual_network" {
#   type        = set(object({
#     action    = string
#     subnet_id = string
#   }))
# }