output "log_analytics_workspace_id" {
  description = "ID de l'espace de travail Log Analytics"
  value       = azurerm_log_analytics_workspace.logs.id
}

output "log_analytics_workspace_name" {
  description = "Nom de l'espace de travail Log Analytics"
  value       = azurerm_log_analytics_workspace.logs.name
}

output "storage_account_id" {
  description = "ID du compte de stockage"
  value       = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = azurerm_storage_account.storage.name
}

output "primary_access_key" {
  description = "Clé d'accès primaire du compte de stockage"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "openmrs_fileshare_name" {
  description = "Nom du partage de fichiers pour OpenMRS"
  value       = azurerm_storage_share.openmrs_data.name
}