#####################
# DNS Zone
#####################

resource "azurerm_dns_zone" "audioprothese_ovh" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group
}
