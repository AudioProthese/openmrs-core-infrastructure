#####################
# Data Sources
#####################

data "azurerm_client_config" "current" {
}

data "azurerm_container_registry" "acr" {
  name                = "openmrscoredevacr"
  resource_group_name = var.resource_group
}
