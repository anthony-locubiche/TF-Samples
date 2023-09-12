variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "subnet_id" {
}
variable "vm_name" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "OS_publisher" {
  type = string
}
variable "OS_offer" {
  type = string
}
variable "OS_version" {
  type = string
}
variable "OS_sku" {
  type = string
}
variable "nic_ip_configuration_name" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "keyvault_id" {
}
variable "os_disk_size_gb" {
  type = number
}
variable "tags" {
}
variable "enabled_vm_agent" {
  type = bool
  default = true
}