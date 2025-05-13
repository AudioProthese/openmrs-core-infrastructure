#####################
# Data Sources
#####################

data "azurerm_client_config" "current" {
}

data "azurerm_container_registry" "acr" {
  name                = "openmrsdevacr"
  resource_group_name = var.resource_group
}
