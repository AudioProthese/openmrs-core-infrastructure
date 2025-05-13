# ##########################
# # Resource Group
# ##########################

# resource "azurerm_container_registry" "acr" {
#   name                = "${var.project}${var.env}acr"
#   resource_group_name = var.resource_group
#   location            = var.location
#   sku                 = "Standard"
# }
