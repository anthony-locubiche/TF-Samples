#https://www.terraform.io/docs/providers/azurerm/r/application_insights.html
resource "azurerm_application_insights" "logs" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    application_type    = "web"
    retention_in_days   = var.retention_days
    tags                = var.tags
}