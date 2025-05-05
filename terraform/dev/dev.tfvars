# dev/terraform.tfvars

# --- Génériques ---

project_name        = "openrmscore"
environment         = "dev"
location            = "francecentral"
resource_group_name = "rg-openrmscore-dev"

tags = {
  project     = "openrmscore"
  environment = "dev"
}

# --- Réseau (module network) ---

vnet_address_space = ["10.10.0.0/16"]
nsg_rules = {
  aca   = []
  appgw = []
}
subnets = {
  aca = {
    cidr       = "10.10.1.0/24"
    delegation = "Microsoft.App/environments"
  }
  # appgw = {
  #   cidr       = "10.10.2.0/24"
  #   delegation = null
  # }
}

# --- ACR / Key Vault SKU ---
sku               = "Basic"
sku_name_keyvault = "standard"

# --- Key Vault parameters ---

soft_delete_retention_days    = 7
purge_protection_enabled      = true
public_network_access_enabled = true
enable_rbac_authorization     = true
admin_object_id               = "7039aa21-edae-48d2-932b-51c35303ff75"

# --- DNS ZONE --- # 

zone_name = "openrms.fchevalier.net"

# --- My SQL (module db) ---

database_name            = "openrmsdb"
db_admin_login           = "sqladmin"
db_backup_retention_days = 7
db_sku_name              = "B_Standard_B1ms"
db_max_size_gb           = 20
public_network_access_db = "Enabled"

# --- Azure Container App (container-app module) ---

# Container App Environment configuration
app_environment = {
  name                           = "openrmscore-dev-env"
  internal_load_balancer_enabled = false
  logs_destination               = "log-analytics"
  workload_profile = {
    name          = "Consumption"
    type          = "Consumption"
    minimum_count = 1
    maximum_count = 3
  }
}

# Storage configuration for Container App Environment
storage = {
  name        = "openrms-storage"
  access_mode = "ReadWrite"
}

# Common configuration for all container apps
common_config = {
  base_name                  = "openrmscore-dev-app"
  revision_mode              = "Single"
  min_replicas               = 1
  max_replicas               = 5
  ingress_transport          = "http"
  allow_insecure_connections = true
  traffic_weights = [
    {
      latest_revision = true
      percentage      = 100
    }
  ]
}

# Gateway application configuration
gateway = {
  enabled        = true
  name_suffix    = "gateway"
  container_name = "gateway"
  image          = "openrmscoredevacr.azurecr.io/openrmscore-gateway:latest"
  cpu            = 1
  memory         = "2Gi"
  env_vars = {
    FRONTEND_URL = "openrmscore-dev-app-frontend"
    BACKEND_URL  = "openrmscore-dev-app-backend"
  }
  ingress = {
    external_enabled = true
    target_port      = 80
  }
}

# Frontend application configuration
frontend = {
  enabled        = true
  name_suffix    = "frontend"
  container_name = "frontend"
  image          = "openrmscoredevacr.azurecr.io/openrmscore-frontend:latest"
  cpu            = 1
  memory         = "2Gi"
  env_vars = {
    API_URL            = "/openmrs"
    SPA_PATH           = "/openmrs/spa"
    SPA_CONFIG_URLS    = "/openmrs/spa/config-core_demo.json"
    SPA_DEFAULT_LOCALE = ""
  }
  ingress = {
    external_enabled = false
    target_port      = 80
  }
}

# Backend application configuration
backend = {
  enabled        = true
  name_suffix    = "backend"
  container_name = "backend"
  image          = "openrmscoredevacr.azurecr.io/openrmscore-backend:latest"
  cpu            = 1
  memory         = "2Gi"
  ingress = {
    external_enabled = false
    target_port      = 8080
  }
  volume = {
    enabled      = true
    name         = "openmrs-data"
    path         = "/openmrs/data"
    storage_type = "AzureFile"
  }
}

# --- Application Gateway (module app-gateway) ---
# app_gateway_sku_name                = "Standard_v2"
# app_gateway_sku_tier                = "Standard_v2"
# app_gateway_sku_capacity            = 2
# app_gateway_frontend_port           = 80
# app_gateway_gateway_ip_config_name  = "gatewayIpConfig"
# app_gateway_frontend_ip_config_name = "frontendIpConfig"
# app_gateway_frontend_port_name      = "frontendPort"
# app_gateway_backend_pool_name       = "backendPool"
# app_gateway_http_setting_name       = "httpSetting"
# app_gateway_listener_name           = "httpListener"
# app_gateway_rule_name               = "rule"
# sku_capacity                        = 2
# app_gateway_backend_port            = 80