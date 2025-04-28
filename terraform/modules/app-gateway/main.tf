resource "azurerm_public_ip" "this" {
  name                = format("%s-pip", var.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_config_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = var.backend_pool_name
    ip_addresses = [
      for addr in var.backend_addresses : addr.ip_address
      if can(addr.ip_address)
    ]
  }

  backend_http_settings {
    name                                = var.http_setting_name
    cookie_based_affinity               = "Disabled"
    port                                = var.backend_port
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
    probe_name                          = "health-probe"
  }

  probe {
    name                = "health-probe"
    protocol            = "Http"
    host                = var.test
    path                = "/healthz"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    port                = 80
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_config_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.rule_name
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_pool_name
    backend_http_settings_name = var.http_setting_name
  }

  tags = var.tags
}

