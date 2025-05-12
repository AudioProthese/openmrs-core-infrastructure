##########################
# Resource Group
##########################

resource "azurerm_container_registry" "acr" {
  name                = "${var.project}${var.env}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  lifecycle {
    prevent_destroy = true
  }
}
