terraform {
  backend "azurerm" {
    resource_group_name = "sandbox-terraform-demo"
    storage_account_name = "sandboxtflogs"
    container_name = "sandbox"
    key = "terraform.tfstate"
  }
}
