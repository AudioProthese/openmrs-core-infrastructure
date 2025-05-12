##########################
# Resource Group
##########################

resource "azurerm_resource_group" "rg" {
  name     = var.project
  location = var.location
}
