output "container_app_id" {
  description = "ID de l'Azure Container App"
  value       = azurerm_container_app.app.id
}

output "container_app_fqdn" {
  description = "FQDN de l'App (ingress[0].fqdn)"
  value       = azurerm_container_app.app.ingress[0].fqdn
}

output "internal_load_balancer_ip" {
  description = "IP statique de l'ILB"
  value       = azurerm_container_app_environment.this.static_ip_address
}
