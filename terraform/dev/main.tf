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
  source                       = "../modules/db"
  server_name                  = format("%s-%s-mysql", var.project_name, var.environment)
  resource_group_name          = var.resource_group_name
  location                     = var.location
  database_name                = var.database_name
  administrator_login          = var.db_admin_login
  administrator_login_password = data.azurerm_key_vault_secret.db_admin_password.value
  backup_retention_days        = var.db_backup_retention_days
  public_network_access_db     = var.public_network_access_db
  sku_name                     = var.db_sku_name
  max_size_gb                  = var.db_max_size_gb
  tags                         = var.tags
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

# 5. Monitoring (workspace + storage pour logs et données openrms)
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
  openrms_fileshare_name       = "openrms-data"
  openrms_fileshare_quota      = 10
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
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  environment = {
    name                           = var.app_environment.name
    subnet_id                      = module.network.subnet_ids["aca"]
    internal_load_balancer_enabled = var.app_environment.internal_load_balancer_enabled
    logs_destination               = var.app_environment.logs_destination
    log_analytics_workspace_id     = module.monitoring_storage.log_analytics_workspace_id
    workload_profile = {
      name          = var.app_environment.workload_profile.name
      type          = var.app_environment.workload_profile.type
      minimum_count = var.app_environment.workload_profile.minimum_count
      maximum_count = var.app_environment.workload_profile.maximum_count
    }
  }

  storage = {
    name         = var.storage.name
    account_name = module.monitoring_storage.storage_account_name
    share_name   = module.monitoring_storage.openrms_fileshare_name
    access_key   = module.monitoring_storage.primary_access_key
    access_mode  = var.storage.access_mode
  }

  common_config = {
    base_name                  = var.common_config.base_name
    revision_mode              = var.common_config.revision_mode
    min_replicas               = var.common_config.min_replicas
    max_replicas               = var.common_config.max_replicas
    ingress_transport          = var.common_config.ingress_transport
    allow_insecure_connections = var.common_config.allow_insecure_connections
    user_assigned_identity_ids = [module.container_uai.identity_id]
    registry = {
      server      = module.acr.acr_login_server
      identity_id = module.container_uai.identity_id
    }
    traffic_weights = var.common_config.traffic_weights
  }

  gateway = {
    enabled        = var.gateway.enabled
    name_suffix    = var.gateway.name_suffix
    container_name = var.gateway.container_name
    image          = var.gateway.image
    cpu            = var.gateway.cpu
    memory         = var.gateway.memory
    env_vars       = var.gateway.env_vars
    ingress = {
      external_enabled = var.gateway.ingress.external_enabled
      target_port      = var.gateway.ingress.target_port
    }
  }

  frontend = {
    enabled        = var.frontend.enabled
    name_suffix    = var.frontend.name_suffix
    container_name = var.frontend.container_name
    image          = var.frontend.image
    cpu            = var.frontend.cpu
    memory         = var.frontend.memory
    env_vars       = var.frontend.env_vars
    ingress = {
      external_enabled = var.frontend.ingress.external_enabled
      target_port      = var.frontend.ingress.target_port
    }
  }

  backend = {
    enabled        = var.backend.enabled
    name_suffix    = var.backend.name_suffix
    container_name = var.backend.container_name
    image          = var.backend.image
    cpu            = var.backend.cpu
    memory         = var.backend.memory
    omrs_configs = {
      OMRS_CONFIG_MODULE_WEB_ADMIN     = "true"
      OMRS_CONFIG_AUTO_UPDATE_DATABASE = "true"
      OMRS_CONFIG_CREATE_TABLES        = "true"
      OMRS_CONFIG_CONNECTION_SERVER    = module.db.server_fqdn
      OMRS_CONFIG_CONNECTION_DATABASE  = module.db.database_name
      OMRS_CONFIG_CONNECTION_USERNAME  = var.db_admin_login
      OMRS_CONFIG_CONNECTION_PASSWORD  = data.azurerm_key_vault_secret.db_admin_password.value
    }
    ingress = {
      external_enabled = var.backend.ingress.external_enabled
      target_port      = var.backend.ingress.target_port
    }
    volume = {
      enabled      = var.backend.volume.enabled
      name         = var.backend.volume.name
      path         = var.backend.volume.path
      storage_type = var.backend.volume.storage_type
    }
  }
}
# 7. Application Gateway (reverse-proxy sur le Container App)
# module "app_gateway" {
#   source                  = "../modules/app-gateway"
#   depends_on              = [module.container_app]
#   name                    = format("%s-%s-gw", var.project_name, var.environment)
#   resource_group_name     = var.resource_group_name
#   location                = var.location
#   subnet_id               = module.network.subnet_ids["appgw"]
#   sku_name                = var.app_gateway_sku_name
#   sku_tier                = var.app_gateway_sku_tier
#   sku_capacity            = var.app_gateway_sku_capacity
#   frontend_port           = var.app_gateway_frontend_port
#   gateway_ip_config_name  = var.app_gateway_gateway_ip_config_name
#   frontend_ip_config_name = var.app_gateway_frontend_ip_config_name
#   frontend_port_name      = var.app_gateway_frontend_port_name
#   backend_pool_name       = var.app_gateway_backend_pool_name
#   http_setting_name       = var.app_gateway_http_setting_name
#   listener_name           = var.app_gateway_listener_name
#   rule_name               = var.app_gateway_rule_name
#   backend_port            = var.app_gateway_backend_port
#   test                    = module.container_app.container_app_fqdn
#   backend_addresses = [
#     {
#       ip_address = module.container_app.internal_load_balancer_ip
#     }
#   ]

#   tags = var.tags
# }
