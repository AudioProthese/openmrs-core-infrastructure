##########################
# AKS
##########################

resource "azurerm_kubernetes_cluster" "aks" {
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

resource "azurerm_role_assignment" "aks-dns-role-by-id" {
  scope                            = azurerm_dns_zone.audioprothese_ovh.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.web_app_routing[0].web_app_routing_identity[0].object_id
  skip_service_principal_aad_check = true
}
