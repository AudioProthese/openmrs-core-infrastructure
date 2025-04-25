output "application_gateway_id" {
  description = "ID de l'Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "public_ip_id" {
  description = "ID de l'IP publique associée"
  value       = azurerm_public_ip.this.id
}

output "public_ip" {
  description = "Adresse IP publique de l'Application Gateway"
  value       = azurerm_public_ip.this.ip_address
}