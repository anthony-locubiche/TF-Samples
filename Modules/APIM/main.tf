#https://www.terraform.io/docs/providers/azurerm/r/api_management.html
#https://www.terraform.io/docs/providers/azurerm/r/api_management_product.html
resource "azurerm_api_management_product" "product" {
  product_id            = var.product_id
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  display_name          = var.product_id
  subscription_required = true
  approval_required     = false
  published             = true
}

# resource "azurerm_api_management_product_group" "product_group" {
#   product_id          = azurerm_api_management_product.product.product_id
#   group_name          = var.group_name
#   api_management_name = var.api_management_name
#   resource_group_name = var.resource_group_name
# }
