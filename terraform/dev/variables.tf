variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "openrmscore"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
  type        = string
}

variable "location" {
  description = "Azure location"
  default     = "francecentral"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  default     = "rg-openrmscore-dev"
  type        = string
}

variable "zone_name" {
  description = "Name of the DNS zone (e.g., example.com)"
  default     = "openrms.fchevalier.net"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"         # Valeur fixe au lieu de var.environment
    project     = "openrmscore" # Valeur fixe au lieu de var.project_name
  }
}

variable "sku" {
  description = "SKU of the Azure Container Registry (e.g., Basic, Standard, Premium)"
  default     = "Basic"
  type        = string

}

variable "sku_name_keyvault" {
  description = "SKU of the Key Vault (standard or premium)"
  default     = "standard"
  type        = string

}

variable "vnet_address_space" {
  description = "List of address spaces for the Virtual Network (VNet)"
  default     = ["10.10.0.0/16"]
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets with their CIDR blocks and optional delegation"
  default = {
    aca = {
      cidr       = "10.10.1.0/24"
      delegation = "Microsoft.App/environments"
    }
    appgw = {
      cidr       = "10.10.2.0/24"
      delegation = null
    }
  }
  type = map(object({
    cidr       = string
    delegation = optional(string)
  }))
}

variable "db_admin_login" {
  description = "Login administrateur SQL"
  default     = "sqladmin"
  type        = string
}

variable "db_public_network_access_enabled" {
  description = "Autoriser l'accès public au serveur SQL"
  default     = false
  type        = bool
}

variable "db_minimum_tls_version" {
  description = "Version TLS minimale pour le serveur SQL"
  default     = "1.2"
  type        = string
}

variable "db_outbound_network_restriction_enabled" {
  description = "Restreindre le trafic sortant du serveur SQL"
  default     = false
  type        = bool
}

variable "db_identity_type" {
  description = "Type d'identité Managed Identity pour le serveur SQL"
  default     = "SystemAssigned"
  type        = string
}

variable "db_identity_ids" {
  description = "The list of identity IDs to assign to the database."
  type        = list(string)
  default     = []
}

variable "admin_object_id" {
  description = "Object ID of the admin user for the Key Vault"
  type        = string
  default     = "7039aa21-edae-48d2-932b-51c35303ff75"
}