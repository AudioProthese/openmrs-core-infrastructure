#####################
# Data Sources
#####################

data "azurerm_client_config" "current" {
}

data "azuread_user" "current_user" {
  user_principal_name = "msi_tdp279@supdevinci-edu.fr"
}