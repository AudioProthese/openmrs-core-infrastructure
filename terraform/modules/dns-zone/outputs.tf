output "name_servers" {
  value = azurerm_dns_zone.public.name_servers
}

output "zone_name" {
  value = azurerm_dns_zone.public.name
}