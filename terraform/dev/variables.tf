## GENERIQUE 

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
}

##  ----------  DNS ZONE ----------------- ##

variable "zone_name" {
  description = "Name of the DNS zone (e.g., example.com)"
  type        = string
}

## ----------- ACR ----------------- ##

variable "sku" {
  description = "SKU of the Azure Container Registry (e.g., Basic, Standard, Premium)"
  default     = "Basic"
  type        = string

}

## -------------- KEY VAULT ----------------- ##

variable "sku_name_keyvault" {
  description = "SKU of the Key Vault (standard or premium)"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Autoriser l’accès public au vault (false = lock‑down réseau)"
  type        = bool
}
variable "soft_delete_retention_days" {
  description = "Durée de rétention (jours) avant soft‑delete"
  type        = number
}
variable "purge_protection_enabled" {
  description = "Activer la purge protection (empêche la purge une fois soft‑deleted)"
  type        = bool
}
variable "admin_object_id" {
  description = "Object ID du service principal ou Managed Identity qui aura le rôle Secrets Officer"
  type        = string
}

variable "enable_rbac_authorization" {
  description = "Utiliser l'authorisation RBAC (true) ou les Access Policies (false)"
  type        = bool
}

## ------------- NETWORK ----------------- ##

variable "vnet_address_space" {
  description = "List of address spaces for the Virtual Network (VNet)"
  default     = ["10.10.0.0/16"]
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets with their CIDR blocks and optional delegation"
  type = map(object({
    cidr       = string
    delegation = optional(string)
  }))
}

variable "nsg_rules" {
  description = "Map of subnets with their CIDR blocks and optional delegation"
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })))
  default = {}
}


## ------------------ Database variables ------------------ ##

variable "database_name" {
  description = "Name of the database for OpenMRS"
  type        = string
}

variable "db_admin_login" {
  description = "Administrator username for MySQL"
  type        = string
}

variable "db_backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
}

variable "db_sku_name" {
  description = "SKU name for MySQL Flexible Server (e.g., B_Standard_B1ms)"
  type        = string
}

variable "db_max_size_gb" {
  description = "Maximum storage size in GB for MySQL server"
  type        = number
}

variable "public_network_access_db" {
  description = "Autoriser l'accès public au serveur MySQL"
  type        = string
}


## ------------- APP GATEWAY ---------------- ##

# variable "app_gateway_sku_name" {
#   description = "SKU name (Standard_v2, WAF_v2…)"
#   type        = string
# }

# variable "app_gateway_sku_tier" {
#   description = "SKU tier"
#   type        = string
# }

# variable "app_gateway_sku_capacity" {
#   description = "Nombre d'instances"
#   type        = number
# }

# variable "app_gateway_frontend_port" {
#   description = "Port HTTP exposé"
#   type        = number
# }

# variable "app_gateway_gateway_ip_config_name" {
#   description = "Nom de la config IP interne"
#   type        = string
# }

# variable "app_gateway_frontend_ip_config_name" {
#   description = "Nom de la config IP publique"
#   type        = string
# }

# variable "app_gateway_frontend_port_name" {
#   description = "Nom du port frontal de l'App Gateway"
#   type        = string
# }

# variable "app_gateway_backend_pool_name" {
#   description = "Nom du pool d'adresses backend de l'App Gateway"
#   type        = string
# }

# variable "app_gateway_http_setting_name" {
#   description = "Nom du HTTP Setting de l'App Gateway"
#   type        = string
# }

# variable "app_gateway_listener_name" {
#   description = "Nom du listener de l'App Gateway"
#   type        = string
# }

# variable "app_gateway_rule_name" {
#   description = "Nom de la règle de routage de l'App Gateway"
#   type        = string
# }

# variable "app_gateway_backend_port" {
#   description = "Port to use for backend HTTP settings"
#   type        = number
# }

# variable "sku_capacity" {
#   description = "Nombre d'instances de l'App Gateway"
#   type        = number
# }

## -------- AZURE CONTAINER --------- APPS

variable "internal_load_balancer_enabled" {
  description = "Whether to enable internal load balancer"
  type        = bool
}

variable "logs_destination" {
  description = "Destination for logs"
  type        = string
}

variable "revision_mode" {
  description = "Revision mode for the Container App"
  type        = string
}

variable "workload_profile_name" {
  description = "Name of the workload profile"
  type        = string
}

variable "workload_profile_type" {
  description = "Type of workload profile to use (e.g., D4, E4, etc.)"
  type        = string
}

variable "workload_profile_min_count" {
  description = "Minimum count of the workload profile"
  type        = number
}

variable "workload_profile_max_count" {
  description = "Maximum count of the workload profile"
  type        = number
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
}

variable "enable_frontend" {
  description = "Whether to enable the frontend container"
  type        = bool
}

variable "enable_backend" {
  description = "Whether to enable the backend container"
  type        = bool
}

variable "enable_backend_volume" {
  description = "Whether to enable volume for the backend container"
  type        = bool
}

variable "enable_gateway" {
  description = "Whether to enable the gateway container"
  type        = bool
}

variable "ingress_external_enabled" {
  description = "Whether to enable external ingress"
  type        = bool
}

variable "target_port" {
  description = "Target port for ingress"
  type        = number
}

variable "ingress_transport" {
  description = "Transport protocol for ingress"
  type        = string
}

variable "traffic_weights" {
  description = "Traffic weights configuration"
  type = list(object({
    latest_revision = bool
    revision_suffix = optional(string)
    percentage      = number
  }))
}

variable "container_apps" {
  description = "Configuration for container apps (frontend, backend, gateway)"
  type = map(object({
    name     = string
    image    = string
    cpu      = number
    memory   = string
    env_vars = map(string)
  }))
}


variable "allow_insecure_connections" {
  description = "Allow insecure connections for the gateway"
  type        = bool
}

variable "environment_storage_name" {
  description = "Name of the container app environment storage integration"
  type        = string
}

variable "environment_storage_access_mode" {
  description = "Access mode for the container app environment storage"
  type        = string
}
