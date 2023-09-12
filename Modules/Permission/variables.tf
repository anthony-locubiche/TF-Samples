variable "scope" {
  description = "The name of the resource  in wich the permission will be applied"
}

variable "role_definition_name" {
  description = "the permission name to apply (must be exist)"
}


variable "spn_list" {
  description = "list of spn to set the permission"
  type        = list(any)
  default     = []
}

variable "group_list" {
  description = "list of group  to set the permission"
  type        = list(any)
  default     = []
}
