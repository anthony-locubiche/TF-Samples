variable "environment" {
  description = "Name of the environment"
}

variable "policy_name" {
  description = "Name of the policy to create"
}

variable "access_controls" {
  description = "Assign permissions on the policy (CAN_USE) for the specified group(s)"
}

variable "policy_overrides" {
  description = "Cluster policy overrides"
}