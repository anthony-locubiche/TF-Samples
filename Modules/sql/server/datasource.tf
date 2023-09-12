data "azurerm_subscription" "current" {
}

# #STORAGE ACCOUNT
# data "azurerm_storage_account" "storage_account" {
#   name = lower("${var.infra_prefix.storage.storage_account}00${var.infra_prefix.general.app_name}datalake00${var.environment}")
#   resource_group_name = lower("${var.infra_prefix.general.resource_group}${data.azurerm_subscription.current.display_name}-${var.environment}-storage")
# }