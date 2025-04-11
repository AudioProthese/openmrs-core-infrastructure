output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_aca_id" {
  description = "ID of the Subnet for Azure Container Apps"
  value       = one([for s in azurerm_virtual_network.vnet.subnet : s.id if s.name == local.subnets.aca.name])
}

output "subnet_appgw_id" {
  description = "ID of the Subnet for the Application Gateway"
  value       = one([for s in azurerm_virtual_network.vnet.subnet : s.id if s.name == local.subnets.appgw.name])
}