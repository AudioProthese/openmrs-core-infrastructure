##########################
# AKS
##########################

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = join("-", [var.project, var.env, var.organization, "aks"])
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
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
    dns_zone_ids = []
  }

  tags = {
    Environment  = var.env
    project      = var.project
    organization = var.organization
  }
}
