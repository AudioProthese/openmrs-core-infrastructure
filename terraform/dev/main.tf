# 1. KV
module "keyvault" {
  source                        = "../modules/keyvault"
  key_vault_name                = format("%s-%s-kv", var.project_name, var.environment)
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.sku_name_keyvault
  public_network_access_enabled = var.public_network_access_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  enable_rbac_authorization     = var.enable_rbac_authorization
  data_plane_principals = [
    {
      name            = "kv-admin"
      principal_id    = var.admin_object_id
      role_definition = "Key Vault Administrator"
    },
    {
      name            = "kv-secrets-officer"
      principal_id    = data.azurerm_client_config.current.object_id
      role_definition = "Key Vault Secrets Officer"
    }
  ]
  tags = var.tags
}

# 1. Network (VNet + subnets + NSG)

module "network" {
  source              = "../modules/network"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
  nsg_rules           = var.nsg_rules
  tags                = var.tags
}

# 2. Container registry et DNS Zone (indépendants)
module "acr" {
  source              = "../modules/acr"
  acr_name            = format("%s%sacr", var.project_name, var.environment)
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

# 2. DNS Zone (indépendant)

module "dns_zone" {
  source              = "../modules/dns-zone"
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# 3. Base SQL (dépend de la Key Vault pour le mot de passe stocké)
module "db" {
  source                               = "../modules/db"
  depends_on                           = [module.keyvault]
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  server_name                          = format("%s-%s-sql", var.project_name, var.environment)
  administrator_login                  = var.db_admin_login
  administrator_login_password         = data.azurerm_key_vault_secret.db_admin_password.value
  public_network_access_enabled        = var.db_public_network_access_enabled
  minimum_tls_version                  = var.db_minimum_tls_version
  outbound_network_restriction_enabled = var.db_outbound_network_restriction_enabled
  identity_type                        = var.db_identity_type
  identity_ids                         = var.db_identity_ids
  tags                                 = var.tags

  database_name         = var.database_name
  collation             = var.db_collation
  license_type          = var.db_license_type
  max_size_gb           = var.db_max_size_gb
  read_scale_enabled    = var.db_read_scale_enabled
  sku_name              = var.db_sku_name
  zone_redundant        = var.db_zone_redundant
  backup_retention_days = var.db_backup_retention_days
}

# 4. Injection des secrets dans Vault (après DB)
module "omrs_secrets" {
  source       = "../modules/vault-secrets"
  depends_on   = [module.keyvault, module.db]
  key_vault_id = module.keyvault.key_vault_id

  secrets = {
    OMRS_CONFIG_MODULE_WEB_ADMIN     = "true"
    OMRS_CONFIG_AUTO_UPDATE_DATABASE = "true"
    OMRS_CONFIG_CREATE_TABLES        = "true"
    OMRS_CONFIG_CONNECTION_SERVER    = module.db.server_fqdn
    OMRS_CONFIG_CONNECTION_DATABASE  = module.db.database_name
    OMRS_CONFIG_CONNECTION_USERNAME  = var.db_admin_login
    OMRS_CONFIG_CONNECTION_PASSWORD  = data.azurerm_key_vault_secret.db_admin_password.value
  }
}

# 5. Monitoring (workspace + storage pour logs et données OpenMRS)
module "monitoring_storage" {
  source                       = "../modules/monitoring-storage"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  tags                         = var.tags
  log_analytics_workspace_name = format("%s%slogs", var.project_name, var.environment)
  log_analytics_sku            = "PerGB2018"
  log_retention_days           = 30
  storage_account_name         = format("%s%sstorage", var.project_name, var.environment)
  storage_account_tier         = "Standard"
  storage_replication_type     = "LRS"
  openmrs_fileshare_name       = "openmrs-data"
  openmrs_fileshare_quota      = 10
}

module "container_uai" {
  source              = "../modules/rbac"
  name_prefix         = format("%s-%s", var.project_name, var.environment)
  resource_group_name = var.resource_group_name
  location            = var.location

  role_assignments = [
    {
      name                 = "acr-pull"
      scope                = module.acr.acr_id
      role_definition_name = "AcrPull"
    },
    {
      name                 = "kv-secrets-read"
      scope                = module.keyvault.key_vault_id
      role_definition_name = "Key Vault Secrets User"
    },
    {
      name                 = "storage-file-contributor"
      scope                = module.monitoring_storage.storage_account_id
      role_definition_name = "Storage File Data SMB Share Contributor"
    },
  ]
}

# 6. Azure Container Apps (frontend / internal gateway / backend)
module "container_app" {
  source = "../modules/container-app"
  depends_on = [
    module.network,
    module.acr,
    module.db,
    module.omrs_secrets,
    module.monitoring_storage,
    module.container_uai,
  ]

  # Environment configuration
  resource_group_name             = var.resource_group_name
  location                        = var.location
  container_app_environment_name  = format("%s-%s-env", var.project_name, var.environment)
  container_app_name              = format("%s-%s-app", var.project_name, var.environment)
  aca_subnet_id                   = module.network.subnet_ids["aca"]
  internal_load_balancer_enabled  = var.internal_load_balancer_enabled
  logs_destination                = var.logs_destination
  log_analytics_workspace_id      = module.monitoring_storage.log_analytics_workspace_id
  revision_mode                   = var.revision_mode
  environment_storage_name        = var.environment_storage_name
  environment_storage_access_mode = var.environment_storage_access_mode
  storage_account_name            = module.monitoring_storage.storage_account_name
  openmrs_fileshare_name          = module.monitoring_storage.openmrs_fileshare_name
  primary_access_key              = module.monitoring_storage.primary_access_key

  workload_profile_name      = var.workload_profile_name
  workload_profile_type      = var.workload_profile_type
  workload_profile_min_count = var.workload_profile_min_count
  workload_profile_max_count = var.workload_profile_max_count
  tags                       = var.tags

  # Scaling configuration
  min_replicas = var.min_replicas
  max_replicas = var.max_replicas

  # Frontend container configuration
  enable_frontend          = var.enable_frontend
  container_image_frontend = lookup(var.container_apps, "frontend").image
  cpu_frontend             = lookup(var.container_apps, "frontend").cpu
  memory_frontend          = lookup(var.container_apps, "frontend").memory
  frontend_env_vars        = lookup(var.container_apps, "frontend").env_vars

  # Backend container configuration
  enable_backend          = var.enable_backend
  container_image_backend = lookup(var.container_apps, "backend").image
  cpu_backend             = lookup(var.container_apps, "backend").cpu
  memory_backend          = lookup(var.container_apps, "backend").memory
  omrs_configs = {
    OMRS_CONFIG_MODULE_WEB_ADMIN     = "true"
    OMRS_CONFIG_AUTO_UPDATE_DATABASE = "true"
    OMRS_CONFIG_CREATE_TABLES        = "true"
    OMRS_CONFIG_CONNECTION_SERVER    = module.db.server_fqdn
    OMRS_CONFIG_CONNECTION_DATABASE  = module.db.database_name
    OMRS_CONFIG_CONNECTION_USERNAME  = var.db_admin_login
    OMRS_CONFIG_CONNECTION_PASSWORD  = data.azurerm_key_vault_secret.db_admin_password.value
  }

  # Backend volume configuration
  enable_backend_volume = var.enable_backend_volume
  backend_volume_path   = "/openmrs/data"
  storage_type          = "AzureFile"

  # Gateway container configuration 
  enable_gateway          = var.enable_gateway
  container_image_gateway = lookup(var.container_apps, "gateway").image
  cpu_gateway             = lookup(var.container_apps, "gateway").cpu
  memory_gateway          = lookup(var.container_apps, "gateway").memory
  gateway_env_vars        = lookup(var.container_apps, "gateway").env_vars

  # Ingress configuration
  enable_ingress           = var.enable_ingress
  ingress_external_enabled = var.ingress_external_enabled
  target_port              = var.target_port
  ingress_transport        = var.ingress_transport
  traffic_weights          = var.traffic_weights

  # Identity and registry configuration
  user_assigned_identity_ids = [module.container_uai.identity_id]
  registry_server            = module.acr.acr_login_server
  registry_identity_id       = module.container_uai.identity_id
}
# 7. Application Gateway (reverse-proxy sur le Container App)
module "app_gateway" {
  source                  = "../modules/app-gateway"
  depends_on              = [module.container_app]
  name                    = format("%s-%s-gw", var.project_name, var.environment)
  resource_group_name     = var.resource_group_name
  location                = var.location
  subnet_id               = module.network.subnet_ids["appgw"]
  sku_name                = var.app_gateway_sku_name
  sku_tier                = var.app_gateway_sku_tier
  sku_capacity            = var.app_gateway_sku_capacity
  frontend_port           = var.app_gateway_frontend_port
  gateway_ip_config_name  = var.app_gateway_gateway_ip_config_name
  frontend_ip_config_name = var.app_gateway_frontend_ip_config_name
  frontend_port_name      = var.app_gateway_frontend_port_name
  backend_pool_name       = var.app_gateway_backend_pool_name
  http_setting_name       = var.app_gateway_http_setting_name
  listener_name           = var.app_gateway_listener_name
  rule_name               = var.app_gateway_rule_name
  backend_port            = var.app_gateway_backend_port
  backend_addresses = [
    {
      ip_address = module.container_app.internal_load_balancer_ip
    }
  ]

  tags = var.tags
}