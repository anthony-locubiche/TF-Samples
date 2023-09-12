#terraform {
#  required_providers {
#    databricks = {
#      source = "databrickslabs/databricks"
#      version = "0.4.8"
#    }
#  }
#}
resource "azurerm_resource_group" "rg-databricks" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_security_group" "private_empty_nsg" {
  name                = var.private_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-databricks.name #Note:NSG moved to Databricks RG, to be validated
  tags                = var.tags
  depends_on          = [
    azurerm_resource_group.rg-databricks
  ]
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_asso" {
  subnet_id                 = var.private_nsg_subnet_id
  network_security_group_id = azurerm_network_security_group.private_empty_nsg.id
  depends_on = [
    azurerm_network_security_group.private_empty_nsg
  ]
}

resource "azurerm_network_security_group" "public_empty_nsg" {
  name                = var.public_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-databricks.name #Note:NSG moved to Databricks RG, to be validated
  tags                = var.tags
  depends_on          = [
    azurerm_resource_group.rg-databricks
  ]
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_asso" {
  subnet_id                 = var.public_nsg_subnet_id
  network_security_group_id = azurerm_network_security_group.public_empty_nsg.id
  depends_on = [
    azurerm_network_security_group.public_empty_nsg
  ]
}

resource "azurerm_databricks_workspace" "databricks-workspace" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg-databricks.name
  location            = var.location
  sku                 = lower(var.sku)
  tags                = var.tags
  custom_parameters {
    no_public_ip        = var.no_public_ip
    virtual_network_id  = var.virtual_network_id
    private_subnet_name                                  = var.private_subnet_name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private_nsg_asso.id
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public_nsg_asso.id
  }
  depends_on = [
    azurerm_resource_group.rg-databricks,
    azurerm_subnet_network_security_group_association.private_nsg_asso,
    azurerm_subnet_network_security_group_association.public_nsg_asso
  ]
}

#Log Analytics
module "databricks_log" {
  source = "../../loganalytics/monitordiagnosticsetting"
  target_resource_name         = azurerm_databricks_workspace.databricks-workspace.name
  target_resource_id           = azurerm_databricks_workspace.databricks-workspace.id
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_id   = var.log_analytics_workspace_id
  depends_on = [
    azurerm_databricks_workspace.databricks-workspace
  ]
}

#Assign users from given groups
#resource "databricks_user" "users" {
#  provider = databricks
#  for_each  = toset(local.users_object_id)
#  user_name = data.azuread_user.users[each.value].mail
#}
#
#resource "databricks_group_member" "i-am-user" {
#  provider = databricks
#  for_each = toset(local.users_object_id)
#  group_id  = data.databricks_group.group.id
#  member_id = databricks_user.users[each.value].id
#}