variable "instance_pool_name" {
  type    = string
  description = "The name of the instance pool. Must be unique, non-empty, and less than 100 characters."
}
variable "min_idle_instances" {
  type    = number
  description = "The minimum number of idle instances maintained by the pool."
}
variable "max_capacity" {
  type    = number
  description = "The maximum number of instances the pool can contain, including both idle instances and ones in use by clusters."
}
variable "node_type_id" {
  type    = string
  description = "The node type for the instances in the pool. All clusters attached to the pool inherit this node type and the pool’s idle instances are allocated based on this type."
}
variable "idle_instance_autotermination_minutes" {
  type    = number
  description = "The number of minutes that idle instances in excess of the min_idle_instances are maintained by the pool before being terminated. If specified, the time must be between 0 and 10000 minutes. If you specify 0, excess idle instances are removed as soon as possible."
}
variable "access_controls" {
  description = "Define which groups can Manage or Attach to individual instance pools."
}