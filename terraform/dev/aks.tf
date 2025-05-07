# main.tf
# Description: Main Tofu configuration file
# Author: Fab

resource "azurerm_resource_group" "aks" {
  name     = var.prj
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = join("-", [var.prj, var.org, "aks"])
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = join("-", [var.prj, var.org, "dns", "aks"])

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  web_app_routing {
    dns_zone_ids = [azurerm_dns_zone.sdv-ocf-poc.id]
  }
}

resource "azurerm_role_assignment" "aks-dns-role-by-id" {
  scope                = azurerm_dns_zone.sdv-ocf-poc.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.web_app_routing[0].web_app_routing_identity[0].object_id
}
