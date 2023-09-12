#AKS


#Cluster
variable "cluster_name" {
  type    = string
}

variable "location" {
  type    = string 
}

variable "resource_group_name" {
  type    = string
}

variable "dns_prefix" {
  type    = string
}


#Node pool
variable "node_pool_name" {
  type    = string
}

variable "node_count" {
  type    = number
}

variable "vm_size" {
  type    = string
}

variable "vnet_subnet_id" {
  type    = string
}


#Network profil
variable "service_cidr" {
  type    = string
}

variable "dns_service_ip" {
  type    = string
}

variable "docker_bridge_cidr" {
  type    = string
}