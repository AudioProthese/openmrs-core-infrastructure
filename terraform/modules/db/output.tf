output "server_id" {
  description = "ID du MS SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "server_name" {
  description = "Nom du MS SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "server_fqdn" {
  description = "FQDN du MS SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "ID de la base de données"
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "Nom de la base de données"
  value       = azurerm_mssql_database.this.name
}
