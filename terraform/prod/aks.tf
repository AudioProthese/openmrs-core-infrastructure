##########################
# AKS
##########################

resource "azurerm_kubernetes_cluster" "aks" {
  depends_on                = [azurerm_dns_zone.audioprothese_ovh]
  name                      = join("-", [var.project, var.env, var.organization, "aks"])
  location                  = var.location
  resource_group_name       = var.resource_group
  dns_prefix                = join("-", [var.project, var.env, var.organization, "dns", "aks"])
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
    dns_zone_ids = [azurerm_dns_zone.audioprothese_ovh.id]
  }

  tags = {
    Environment  = var.env
    project      = var.project
    organization = var.organization
  }
}
