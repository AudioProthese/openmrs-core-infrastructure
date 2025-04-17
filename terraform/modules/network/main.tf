locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name             = "${local.name_prefix}-${subnet.key}"
      address_prefixes = [subnet.value.cidr]
      dynamic "delegation" {
        for_each = subnet.value.delegation != null ? [subnet.value.delegation] : []
        content {
          name = "${subnet.key}-delegation"
          service_delegation {
            name    = delegation.value
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
        }
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.subnets

  name                = "${local.name_prefix}-nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-${each.key}-Inbound"
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