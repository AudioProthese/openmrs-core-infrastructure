# network/outputs.tf

output "vnet_id" {
  description = "ID du VNet"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Map des IDs de chaque subnet"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "nsg_ids" {
  description = "Map des IDs de chaque NSG"
  value       = { for k, n in azurerm_network_security_group.this : k => n.id }
}
