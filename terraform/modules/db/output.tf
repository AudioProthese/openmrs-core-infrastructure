output "server_id" {
  description = "ID du MySQL Server"
  value       = azurerm_mysql_flexible_server.this.id
}

output "server_name" {
  description = "Nom du MySQL Server"
  value       = azurerm_mysql_flexible_server.this.name
}

output "server_fqdn" {
  description = "FQDN du MySQL Server"
  value       = azurerm_mysql_flexible_server.this.fqdn
}

output "database_id" {
  description = "ID de la base de données"
  value       = azurerm_mysql_flexible_database.this.id
}

output "database_name" {
  description = "Nom de la base de données"
  value       = azurerm_mysql_flexible_database.this.name
}