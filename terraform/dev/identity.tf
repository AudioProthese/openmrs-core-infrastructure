#########################
# Role Assignments 
#########################

# User-assigned managed identity for External Secrets Operator (ESO)
resource "azurerm_user_assigned_identity" "eso_workload_identity" {
  name                = "eso-workload-identity"
  location            = var.location
  resource_group_name = var.resource_group
}

# Role assignment that grants the ESO workload identity permission to read secrets from Key Vault
resource "azurerm_role_assignment" "eso_keyvault_secrets_user" {
  scope                            = azurerm_key_vault.vault.id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_user_assigned_identity.eso_workload_identity.principal_id
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

# Role Assignment for Key Vault Secrets User to your Azure user account
resource "azurerm_role_assignment" "user_keyvault_secret_access" {
  scope                            = azurerm_key_vault.vault.id
  role_definition_name             = "Key Vault Administrator"
  principal_id                     = var.user_object_id
  principal_type                   = "User"
  skip_service_principal_aad_check = true
}

###############################
# Federated Identity Credential
###############################

# OIDC AKS
resource "azurerm_federated_identity_credential" "eso_federated_identity" {
  name                = "eso-federated-credential"
  resource_group_name = azurerm_user_assigned_identity.eso_workload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.eso_workload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:eso:workload-identity-sa"
}
