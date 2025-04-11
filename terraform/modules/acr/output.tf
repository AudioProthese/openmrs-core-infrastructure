output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  description = "The login server (FQDN) of the ACR, used for pulling/pushing images."
  value       = azurerm_container_registry.acr.login_server
}
