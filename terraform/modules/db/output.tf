output "sql_server_id" {
  description = "ID du serveur SQL"
  value       = azurerm_mssql_server.this.id
}

output "sql_server_fqdn" {
  description = "FQDN du serveur SQL"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "administrator_password" {
  description = "Mot de passe généré pour l'administrateur SQL"
  value       = random_password.sql_admin.result
  sensitive   = true
}