resource "azurerm_network_security_group" "platform_nsg" {
  name                = lower("${var.infra_prefix.networking.network_security_group}platform-${var.environment}")
  location            = azurerm_resource_group.rg["platform"].location
  resource_group_name = azurerm_resource_group.rg["platform"].name
}

resource "azurerm_virtual_network" "platform_vnet" {
  for_each = local.networks
  #name                = lower("${each.value.networkName}")
  name                = lower("${each.value.networkSurname}")
  location            = azurerm_resource_group.rg["platform"].location
  resource_group_name = azurerm_resource_group.rg["platform"].name
  address_space       = ["10.0.0.0/24"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "default"
    address_prefix = "10.0.0.0/26" #64 addresses
  }

  subnet {
    name           = "platform"
    address_prefix = "10.0.0.64/26"
    security_group = azurerm_network_security_group.platform_nsg.id
  }

  tags = merge({ "App-Name" = format("%s", upper("COMMON")) }, var.tags.common)

  depends_on = [azurerm_network_security_group.platform_nsg]
}


locals {

  subnets_list = flatten([
    for subnetId, subnet in data.azurerm_subnet.subnets : {
      id = subnet.id
      name = subnet.name
    }
  ])

  _vnets = flatten([
    for vnet_key, vnet in var.networks : {
      networkSurname = vnet_key
      #networkName    = lower("${var.infra_prefix.networking.virtual_network}${vnet.network}-${var.environment}")
      networkRange   = vnet.networkRange
    }
  ])

  _subnets = flatten([
    for vnet_key, vnet in var.networks : [
      for subnet_key, subnet in vnet.subnets : {
        networkSurname = vnet_key
        subnetSurname  = subnet_key
        #networkName    = lower("${var.infra_prefix.networking.virtual_network}-${vnet.network}")
        #subnetName     = lower("${subnet.name}-subnet-${vnet.network}")
        subnetRange    = subnet.range
      }
    ]
  ])

  networks = {
    for obj in local._vnets : obj.networkSurname => obj
  }

  subnets = {
    for obj in local._subnets : "${obj.networkSurname}_${obj.subnetSurname}" => obj
  }

#  sql_authorized_network = flatten([
#    for network  in var.platform.sql_server.authorized_networks : {
#      id = data.azurerm_subnet.subnets[each.key].id
#    }
#  ])

  test = tolist([for rule in var.platform.sql_server.authorized_networks : {
    key = data.azurerm_subnet.subnets[rule].id
  }])

}

