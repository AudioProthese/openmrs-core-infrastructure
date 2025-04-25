# network/main.tf

locals {
  name_prefix = format("%s-%s", var.project_name, var.environment)
}

# 1. Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = "${local.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# 2. Subnets
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = format("%s-%s", local.name_prefix, each.key)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.cidr]


  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = "delegation-${each.key}"
      service_delegation {
        name    = each.value.delegation
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

# 3. Network Security Groups
resource "azurerm_network_security_group" "this" {
  for_each = var.subnets

  name                = format("%s-nsg-%s", local.name_prefix, each.key)
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # si des règles sont fournies pour ce subnet, on les applique, sinon règle par défaut AllowAllInbound
  dynamic "security_rule" {
    for_each = length(var.nsg_rules[each.key]) > 0 ? var.nsg_rules[each.key] : [
      {
        name                       = "AllowAllInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# 4. Association NSG ↔ Subnet
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}
