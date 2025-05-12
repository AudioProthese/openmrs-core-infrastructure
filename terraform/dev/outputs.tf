output "azure-nameservers" {
  value = azurerm_dns_zone.openmrs-fchevalier.name_servers
}
