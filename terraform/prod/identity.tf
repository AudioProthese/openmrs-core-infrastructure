#########################
# Role Assignments 
#########################

# Vault AKS User
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                            = azurerm_key_vault.vault.id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# ACR AKS Pull
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# AKS DNS Zone Contributor
resource "azurerm_role_assignment" "aks_dns" {
  depends_on                       = [azurerm_kubernetes_cluster.aks]
  scope                            = azurerm_dns_zone.audioprothese_ovh.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# AKS Web App Routing DNS Zone Contributor
resource "azurerm_role_assignment" "external_dns" {
  scope                            = azurerm_dns_zone.audioprothese_ovh.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.web_app_routing[0].web_app_routing_identity[0].object_id
  skip_service_principal_aad_check = true
}

###############################
# Federated Identity Credential
###############################

# OIDC AKS
resource "azurerm_federated_identity_credential" "ESOFederatedIdentity" {
  name                = "ESOFederatedIdentity"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_kubernetes_cluster.aks.kubelet_identity[0].user_assigned_identity_id
  subject             = "system:serviceaccount:default:workload-identity-sa"
}
