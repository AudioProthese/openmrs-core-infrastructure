module "network" {
  source              = "../modules/network"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
  tags                = var.tags
}

module "acr" {
  source              = "../modules/acr"
  acr_name            = "${var.project_name}${var.environment}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

module "dns_zone" {
  source              = "../modules/dns-zone"
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  tags = var.tags
}

module "db" {
  source              = "../modules/db"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = "${var.project_name}${var.environment}sql"
  version             = "12.0"
  administrator_login = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
  public_network_access_enabled        = false
  minimum_tls_version                  = "1.2"
  outbound_network_restriction_enabled = false
  identity_type                       = "SystemAssigned"
  tags                = var.tags
  
}

module "keyvault" {
  source              = "../modules/keyvault"
  key_vault_name      = "${var.project_name}-${var.environment}-kv"
  resource_group_name = var.resource_group_name
  location            = var.location

  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  sku_name            = var.sku_name_keyvault
  tags                = var.tags
}