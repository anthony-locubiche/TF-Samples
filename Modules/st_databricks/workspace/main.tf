terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.73.0"
    }
    databricks = {
      source = "databrickslabs/databricks"
      version = ">= 0.3.6"
    }
  }
}

resource "azurerm_resource_group" "rg-databricks" {
  name     = var.rg_name
  location = var.location
  tags     = var.default_tags
}

resource "azurerm_network_security_group" "private_empty_nsg" {
  count               = var.dbricks_private_nsg_name != "" ?  1 : 0

  name                = var.dbricks_private_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-databricks.name #Note:NSG moved to Databricks RG, to be validated
  tags                = var.default_tags
  depends_on          = [
    azurerm_resource_group.rg-databricks
  ]
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_asso" {
  count                     = var.dbricks_private_nsg_name != "" && var.dbricks_private_nsg_subnet_id != "" ?  1 : 0

  subnet_id                 = var.dbricks_private_nsg_subnet_id
  network_security_group_id = azurerm_network_security_group.private_empty_nsg[0].id
  depends_on = [
    azurerm_network_security_group.private_empty_nsg
  ]
}

resource "azurerm_network_security_group" "public_empty_nsg" {
  count               = var.dbricks_public_nsg_name != "" ?  1 : 0

  name                = var.dbricks_public_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-databricks.name #Note:NSG moved to Databricks RG, to be validated
  tags                = var.default_tags
  depends_on          = [
    azurerm_resource_group.rg-databricks
  ]
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_asso" {
  count                     = var.dbricks_public_nsg_name != "" && var.dbricks_public_nsg_subnet_id != "" ?  1 : 0

  subnet_id                 = var.dbricks_public_nsg_subnet_id
  network_security_group_id = azurerm_network_security_group.public_empty_nsg[0].id
  depends_on = [
    azurerm_network_security_group.public_empty_nsg
  ]
}

######################################################################## Databricks Workspace #########################################################################
resource "azurerm_databricks_workspace" "databricks_workspace" {
  count                                                  = var.dbricks_workspace_name != "" ?  1 : 0
  name                                                   = var.dbricks_workspace_name
  resource_group_name                                    = azurerm_resource_group.rg-databricks.name
  location                                               = var.location
  sku                                                    = var.sku
  managed_resource_group_name                            = var.dbricks_managed_rg_name

  custom_parameters {
    virtual_network_id                                   = var.dbricks_virtual_network_id
    public_subnet_name                                   = var.dbricks_public_subnet_name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public_nsg_asso[0].id
    private_subnet_name                                  = var.dbricks_private_subnet_name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private_nsg_asso[0].id
    no_public_ip                                         = var.no_public_ip
  }
  tags                                                   = var.default_tags

  depends_on = [
    azurerm_resource_group.rg-databricks,
    azurerm_subnet_network_security_group_association.private_nsg_asso,
    azurerm_subnet_network_security_group_association.public_nsg_asso
  ]
}

######################################################################## Monitor diagnostic setting ###################################################################
module "azurerm_monitor_diagonostic_setting" {
  source = "../../loganalytics/monitordiagnosticsetting"

  log_analytics_workspace_id   = var.log_analytics_workspace_id
  log_analytics_workspace_name = var.databricks_mds_name
  target_resource_id           = azurerm_databricks_workspace.databricks_workspace[0].id
  target_resource_name         = azurerm_databricks_workspace.databricks_workspace[0].name

  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

######################################################################## Databricks IP Access List ####################################################################
provider "databricks" {
  azure_workspace_resource_id = var.dbricks_workspace_name != "" ? azurerm_databricks_workspace.databricks_workspace[0].id : null
}

# DataBricks Workspace Configuration
resource "databricks_workspace_conf" "databricks_workspace_conf" {
  for_each = var.dbricks_workspace_name != "" && var.databricks_ip != {} ? var.databricks_ip : {}
  custom_config = {
    "enableIpAccessLists": each.value["enableIpAccessLists"]
  }
  depends_on = [
    azurerm_databricks_workspace.databricks_workspace
  ]
}

# DataBricks IP Access List
resource "databricks_ip_access_list" "databricks_ip_access_list" {
  for_each = var.dbricks_workspace_name != "" && var.databricks_ip != {} ? var.databricks_ip : {}
  list_type = each.value["list_type"]
  ip_addresses = each.value["ip_addresses"]
  label = each.value["label"]
  enabled = each.value["enabled"]
  depends_on = [databricks_workspace_conf.databricks_workspace_conf]
}
