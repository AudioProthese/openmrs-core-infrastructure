#####################
# Azure DNS Zone
#####################

resource "azurerm_dns_zone" "audioprothese_ovh" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group
}

######################
# OVH NS Servers
######################

resource "ovh_domain_name_servers" "name_servers" {
  depends_on = [azurerm_dns_zone.audioprothese_ovh]
  domain     = var.dns_zone_name

  dynamic "servers" {
    for_each = azurerm_dns_zone.audioprothese_ovh.name_servers
    content {
      host = replace(servers.value, "\\.$", "")
    }
  }
}
