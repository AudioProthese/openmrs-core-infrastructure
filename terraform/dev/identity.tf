#########################
# Role Assignments
#########################

resource "azurerm_role_assignment" "keyvault_user" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault User"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

###############################
# Federated Identity Credential
###############################

resource "azurerm_federated_identity_credential" "identity" {
  name                = "kubelet-federated-identity"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_kubernetes_cluster.aks.kubelet_identity[0].user_assigned_identity_id
  subject             = "system:serviceaccount:default:workload-identity-sa"
}
