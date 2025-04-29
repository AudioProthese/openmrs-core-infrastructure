output "internal_load_balancer_ip" {
  description = "IP statique de l'ILB"
  value       = azurerm_container_app_environment.this.static_ip_address
}

output "container_app_gateway_fqdn" {
  value = var.enable_gateway ? azurerm_container_app.gateway[0].ingress[0].fqdn : null
}

output "container_app_frontend_fqdn" {
  value = var.enable_frontend ? azurerm_container_app.frontend[0].ingress[0].fqdn : null
}

output "container_app_backend_fqdn" {
  value = var.enable_backend ? azurerm_container_app.backend[0].ingress[0].fqdn : null
}