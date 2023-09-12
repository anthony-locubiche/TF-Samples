#Mountpoint attributes
variable "container_name" {
  type    = string
}
variable "storage_account_name" {
  type    = string
}
variable "mountpoint_name" {
  type    = string
}
variable "tenant_id" {
}
variable "client_id" {
}
variable "client_secret_scope" {
}
variable "client_secret_key" {
  type    = string
}
variable "initialize_file_system" {
  type    = bool
}