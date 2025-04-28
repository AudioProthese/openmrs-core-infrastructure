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
  appgw = {
    cidr       = "10.10.2.0/24"
    delegation = null
  }
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


# --- Application Gateway (module app-gateway) ---
app_gateway_sku_name                = "Standard_v2"
app_gateway_sku_tier                = "Standard_v2"
app_gateway_sku_capacity            = 2
app_gateway_frontend_port           = 80
app_gateway_gateway_ip_config_name  = "gatewayIpConfig"
app_gateway_frontend_ip_config_name = "frontendIpConfig"
app_gateway_frontend_port_name      = "frontendPort"
app_gateway_backend_pool_name       = "backendPool"
app_gateway_http_setting_name       = "httpSetting"
app_gateway_listener_name           = "httpListener"
app_gateway_rule_name               = "rule"
sku_capacity                        = 2
app_gateway_backend_port            = 80

# --- Azure Container App (module azure-container-app) ---
enable_frontend       = true
enable_backend        = true
enable_gateway        = true
enable_backend_volume = true
container_apps = {
  frontend = {
    name   = "frontend-app"
    image  = "openrmscoredevacr.azurecr.io/openrmscore-frontend:latest"
    cpu    = 1
    memory = "2Gi"
    env_vars = {
      API_URL            = "/openmrs"
      SPA_PATH           = "/openmrs/spa"
      SPA_CONFIG_URLS    = "/openmrs/spa/config-core_demo.json"
      SPA_DEFAULT_LOCALE = ""
    }
  }
  backend = {
    name     = "backend-app"
    image    = "openrmscoredevacr.azurecr.io/openrmscore-backend:latest"
    cpu      = 1
    memory   = "2Gi"
    env_vars = {}
  }
  gateway = {
    name   = "gateway-app"
    image  = "openrmscoredevacr.azurecr.io/openrmscore-gateway:latest"
    cpu    = 1
    memory = "2Gi"
    env_vars = {
    }
  }
}
# Environment configuration

revision_mode                   = "Single"
logs_destination                = "log-analytics"
min_replicas                    = 1
max_replicas                    = 5
workload_profile_name           = "Consumption"
workload_profile_type           = "Consumption"
workload_profile_min_count      = 1
workload_profile_max_count      = 3
environment_storage_access_mode = "ReadWrite"
environment_storage_name        = "openrms-storage"
# Ingress configurations

internal_load_balancer_enabled = true
enable_ingress                 = true
ingress_external_enabled       = false
target_port                    = 80
ingress_transport              = "http"
allow_insecure_connections     = true
traffic_weights = [
  {
    latest_revision = true
    percentage      = 100
  }
]