variable "resource_group_name" {
  description = "The name of the resource group in wich all resources will be create"
}

variable "location" {
  description = "The location of the resource"
}

variable "name" {
  description = "The name of the resource"
}

variable "app_plan_id" {
  description = "The id of the app plan in wich the Function will be create"
}

variable "storage_account_name" {
  description = "The storage account name"
}

variable "storage_account_access_key" {
  description = "The storage account key"
}

variable "app_insights_instrumentation_key" {
  description = "The app insights instrumentation key"
}

variable "pre_warmed_instance_count" {
  description = "Number of instances to pre warm"
}

variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module"
}

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace"
}

variable "log_analytics_resource_group_name" {
  description = "Resource group of the log analytics workspace"
}

# variable "managed_identity" {
#   description = "Optional. Identifier of the identity for this resource."
#   default     = ""
# }

variable "APPINSIGHTS_INSTRUMENTATIONKEY" {
  description = "AppInsights Datasource Instrumentation Key"
}

variable "KEYVAULTURI" {
  description = "URI Keyvault"
}

variable "TENANT_ID" {
  description = "Tenant ID"
}

variable "os_type" {
  description = "OS type of the Azure Function"
}

variable "global_app_settings" {
  type = map
}

variable "function_app_settings" {
  type = map
}