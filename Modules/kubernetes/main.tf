resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                      = var.cluster_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.dns_prefix
  private_cluster_enabled   = true

  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.vnet_subnet_id # ID du subnet où vont être mit les nodes et les clusters
  }

  identity {
    type = "SystemAssigned"
  }

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#network_profile
  network_profile {
    network_plugin     = "azure"
    service_cidr       = var.service_cidr        # Doit obligatoirement être un nouveau subnet. Les services kubernetes seront placés ici
    dns_service_ip     = var.dns_service_ip      # Adresse DNS pour les services kubernetes. Doit être intégré dans le subnet des services
    docker_bridge_cidr = var.docker_bridge_cidr  # Ne doit faire partie d'aucun subnet
  }
}


# # SI BESOIN D AJOUTER UN NOUVEAU POOL DE NODE
# resource "azurerm_kubernetes_cluster_node_pool" "node-cluster" {
#   name                  = "internal"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
#   vm_size               = "Standard_DS2_v2"
#   node_count            = 9
# }