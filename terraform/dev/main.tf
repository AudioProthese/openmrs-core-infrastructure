module "keyvault" {
  source              = "../modules/keyvault"
  key_vault_name      = "${var.project_name}-${var.environment}-kv"
  resource_group_name = var.resource_group_name
  location            = var.location

  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  admin_object_id = var.admin_object_id

  sku_name = var.sku_name_keyvault
  tags     = var.tags
}

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
  tags                = var.tags
}

module "db" {
  source                               = "../modules/db"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  server_name                          = "${var.project_name}${var.environment}sql"
  administrator_login                  = var.db_admin_login
  administrator_login_password         = data.azurerm_key_vault_secret.db_admin_password.value
  public_network_access_enabled        = var.db_public_network_access_enabled
  minimum_tls_version                  = var.db_minimum_tls_version
  outbound_network_restriction_enabled = var.db_outbound_network_restriction_enabled
  identity_type                        = var.db_identity_type
  identity_ids                         = var.db_identity_ids
  tags                                 = var.tags
}