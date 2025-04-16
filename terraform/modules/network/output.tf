output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = { for s in azurerm_virtual_network.vnet.subnet : s.name => s.id }
}

output "nsg_ids" {
  description = "Map of Network Security Group IDs"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}