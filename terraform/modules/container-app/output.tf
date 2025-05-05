# Container App Environment essential outputs
output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.this.id
}

output "container_app_environment_default_domain" {
  description = "Default domain of the Container App Environment"
  value       = azurerm_container_app_environment.this.default_domain
}

# Main application access point
output "container_app_fqdn" {
  description = "Main FQDN to access the application (typically the gateway FQDN)"
  value       = var.gateway.enabled && var.gateway.ingress.external_enabled ? azurerm_container_app.gateway[0].ingress[0].fqdn : null
}

# Individual container app outputs
output "gateway_fqdn" {
  description = "FQDN of the Gateway Container App"
  value       = var.gateway.enabled && var.gateway.ingress.external_enabled ? azurerm_container_app.gateway[0].ingress[0].fqdn : null
}

output "backend_id" {
  description = "ID of the Backend Container App"
  value       = var.backend.enabled ? azurerm_container_app.backend[0].id : null
}

output "frontend_id" {
  description = "ID of the Frontend Container App"
  value       = var.frontend.enabled ? azurerm_container_app.frontend[0].id : null
}

output "gateway_id" {
  description = "ID of the Gateway Container App"
  value       = var.gateway.enabled ? azurerm_container_app.gateway[0].id : null
}