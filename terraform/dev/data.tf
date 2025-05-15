#####################
# Data Sources
#####################

data "azurerm_client_config" "current" {
}

data "azurerm_container_registry" "acr" {
  name                = "openmrsdevacr"
  resource_group_name = var.resource_group
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
}
