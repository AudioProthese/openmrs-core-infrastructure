output "identity_id" {
  description = "Resource ID de la User-Assigned Identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Principal ID (object ID) de l’UAI"
  value       = azurerm_user_assigned_identity.this.principal_id
}
