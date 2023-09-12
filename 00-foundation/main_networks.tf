
locals {
  _virtual_network_subnet_ids = flatten([
    for subnetId, subnet in data.azurerm_subnet.subnets : [
      subnet.id
    ]
  ])

  _jenkin_network_subnet_id_name = flatten([{
    id   = data.azurerm_subnet.jenkins-subnet.id
    name = data.azurerm_subnet.jenkins-subnet.name
  }])


  virtual_network_subnet_ids = concat(local._virtual_network_subnet_ids, [data.azurerm_subnet.jenkins-subnet.id])

  _virtual_network_subnet_ids_map = flatten([
    for subnetId, subnet in data.azurerm_subnet.subnets : {
      action    = "Allow"
      subnet_id = subnet.id
    }
  ])

  virtual_network_subnet_ids_map = concat(local._virtual_network_subnet_ids_map, [{ action = "Allow", subnet_id = data.azurerm_subnet.jenkins-subnet.id }])

  _obj_networks_rules = concat(flatten([
    for subnetId, subnet in data.azurerm_subnet.subnets : {
      id   = subnet.id
      name = subnet.name
    }
  ]), local._jenkin_network_subnet_id_name)

  obj_networks_rules = {
    for obj in local._obj_networks_rules : obj.name => obj
  }

  ip_rules = flatten([
    for ip in var.ip_rules : {
      action   = "Allow"
      ip_range = ip
      ip_mask  = ip
    }
  ])

  tmp_net = flatten([
    for vnetId, vnet in var.networks : {
      networkSurname = vnetId
      networkName    = lower("${var.infra_prefix.networking.virtual_network}${data.azurerm_subscription.current.display_name}-${vnet.network}")
    }
  ])

  tmp_sub = flatten([
    for vnetId, vnet in var.networks : [
      for subnet in vnet.subnets : {
        networkSurname = vnetId
        subnetSurname  = subnet
        networkName    = lower("${var.infra_prefix.networking.virtual_network}${data.azurerm_subscription.current.display_name}-${vnet.network}")
        subnetName     = lower("subnet${subnet}-${data.azurerm_subscription.current.display_name}-${vnet.network}")
      }
    ]
  ])

  networks = {
    for obj in local.tmp_net : obj.networkSurname => obj
  }

  subnets = {
    for obj in local.tmp_sub : "${obj.networkSurname}_${obj.subnetSurname}" => obj
  }

  list_virtual_network_rule = flatten([
    for subnetId, subnet in data.azurerm_subnet.subnets : {
      subnet_id                                       = subnet.id
      ignore_missing_virtual_network_service_endpoint = "false"
    }
  ])
}

