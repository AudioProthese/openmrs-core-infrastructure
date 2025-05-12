####################
# Public DNS Zone
####################

resource "azurerm_dns_zone" "openmrs-fchevalier" {
  name                = "audioprothese.fchevalier.net"
  resource_group_name = azurerm_resource_group.aks.name
}