##########################
# Storage Account 
##########################

resource "azurerm_storage_account" "openmrscoredevsa02" {
  name                     = "openmrscoredevsa02"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment  = var.env
    project      = var.project
    organization = var.organization
  }
}

##########################
# Container Storage 
##########################

resource "azurerm_storage_container" "loki-chunks" {
  name                  = "loki-chunks"
  storage_account_id    = azurerm_storage_account.openmrscoredevsa02.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "loki-ruler" {
  name                  = "loki-ruler"
  storage_account_id    = azurerm_storage_account.openmrscoredevsa02.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "loki-admin" {
  name                  = "loki-admin"
  storage_account_id    = azurerm_storage_account.openmrscoredevsa02.id
  container_access_type = "private"
}
