locals {
  name_prefix = "${var.project_name}-${var.environment}"

  subnets = {
    aca = {
      name       = "${local.name_prefix}-subnet-aca"
      cidr       = "10.10.1.0/24"
      delegation = "Microsoft.App/environments"
    }
    appgw = {
      name = "${local.name_prefix}-subnet-appgw"
      cidr = "10.10.3.0/24"
    }
    db = {
      name = "${local.name_prefix}-subnet-db"
      cidr = "10.10.2.0/24"
    }
  }

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = local.tags

 # Subnet for Azure Container Apps
  subnet {
    name             = local.subnets.aca.name
    address_prefixes = [local.subnets.aca.cidr]
    security_group   = azurerm_network_security_group.nsg_aca.id
    delegation {
      name = "aca-delegation"
      service_delegation {
        name    = local.subnets.aca.delegation
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
# Subnet for Application Gateway
  subnet {
    name             = local.subnets.appgw.name
    address_prefixes = [local.subnets.appgw.cidr]
    security_group   = azurerm_network_security_group.nsg_appgw.id
  }
# Subnet for Database
  subnet {
    name             = local.subnets.db.name
    address_prefixes = [local.subnets.db.cidr]
    security_group   = azurerm_network_security_group.nsg_db.id
  }
}
# Network Security Group for Azure Container Apps
resource "azurerm_network_security_group" "nsg_aca" {
  name                = "${local.name_prefix}-nsg-aca"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  security_rule {
    name                       = "Allow-ACA-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Network Security Group for Application Gateway
resource "azurerm_network_security_group" "nsg_appgw" {
  name                = "${local.name_prefix}-nsg-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  security_rule {
    name                       = "Allow-AppGW-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Network Security Group for Database
resource "azurerm_network_security_group" "nsg_db" {
  name                = "${local.name_prefix}-nsg-db"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  security_rule {
    name                       = "Allow-DB-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}