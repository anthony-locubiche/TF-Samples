output "client_certificate" {
  value       = base64decode(azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate)
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}