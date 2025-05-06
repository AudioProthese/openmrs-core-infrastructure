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
  description = "Name of the database for openrms"
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

## -------- AZURE CONTAINER APPS ---------

# Container App Environment configuration
variable "app_environment" {
  description = "Container App Environment configuration"
  type = object({
    name                           = string
    internal_load_balancer_enabled = bool
    logs_destination               = string
    workload_profile = object({
      name          = string
      type          = string
      minimum_count = number
      maximum_count = number
    })
  })
}

# Storage configuration for the environment
variable "storage" {
  description = "Storage configuration for Container App Environment"
  type = object({
    name        = string
    access_mode = string
  })
}

# Common configuration for all container apps
variable "common_config" {
  description = "Common configuration for all container apps"
  type = object({
    base_name                  = string
    revision_mode              = string
    min_replicas               = number
    max_replicas               = number
    ingress_transport          = string
    allow_insecure_connections = bool
    traffic_weights = list(object({
      latest_revision = bool
      revision_suffix = optional(string)
      percentage      = number
    }))
  })
}

# Gateway application configuration
variable "gateway" {
  description = "Gateway container app configuration"
  type = object({
    enabled        = bool
    name_suffix    = string
    container_name = string
    image          = string
    cpu            = number
    memory         = string
    env_vars       = map(string)
    ingress = object({
      external_enabled = bool
      target_port      = number
    })
  })
}

# Frontend application configuration
variable "frontend" {
  description = "Frontend container app configuration"
  type = object({
    enabled        = bool
    name_suffix    = string
    container_name = string
    image          = string
    cpu            = number
    memory         = string
    env_vars       = map(string)
    ingress = object({
      external_enabled = bool
      target_port      = number
    })
  })
}

# Backend application configuration
variable "backend" {
  description = "Backend container app configuration"
  type = object({
    enabled        = bool
    name_suffix    = string
    container_name = string
    image          = string
    cpu            = number
    memory         = string
    ingress = object({
      external_enabled = bool
      target_port      = number
    })
    volume = object({
      enabled      = bool
      name         = string
      path         = string
      storage_type = string
    })
  })
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
