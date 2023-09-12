#EVENTHUB


variable "name" {
  type = string
}

variable "namespace_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "partition_count" {
  type = number
}

variable "message_retention" {
  type = string

}

variable "permission" {
  type = map(object({
    listen = bool
    send   = bool
    manage = bool
  }))
}

variable "key_vault_id" {
  type = string
}