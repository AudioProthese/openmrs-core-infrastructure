##########################
# Resource Group
##########################

resource "azurerm_container_registry" "acr" {
  name                = "${var.project}acr${var.env}"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard"
}
