# Log Analytics pour la surveillance
resource "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Storage Account pour les volumes persistants
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  tags                     = var.tags
}

# Partage de fichiers pour persister les données OpenMRS
resource "azurerm_storage_share" "openmrs_data" {
  name               = var.openmrs_fileshare_name
  storage_account_id = azurerm_storage_account.storage.id
  quota              = var.openmrs_fileshare_quota
}