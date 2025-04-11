output "name_servers" {
  value = var.public_dns_zone ? azurerm_dns_zone.public[0].name_servers : null
}


output "zone_name" {
  value = var.zone_name
}