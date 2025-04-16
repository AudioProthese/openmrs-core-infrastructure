output "key_vault_id" {
  description = "ID du Key Vault créé"
  value       = azurerm_key_vault.this.id
}

output "key_vault_uri" {
  description = "URI du Key Vault (pour stocker/récupérer des secrets)"
  value       = azurerm_key_vault.this.vault_uri
}
