# dns.tf
# Description: Manage DNS zone using Azure DNS
# Author: Fab

resource "azurerm_dns_zone" "sdv-ocf-poc" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.aks.name
}