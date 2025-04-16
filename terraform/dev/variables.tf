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

variable "vnet_address_space" {
  description = "List of address spaces for the Virtual Network (VNet)"
  default     = ["10.10.0.0/16"]
  type        = list(string)
}

variable "zone_name" {
  description = "Name of the DNS zone (e.g., example.com)"
  default     = "openrms.fchevalier.net"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {
    environment = var.environment
    project     = var.project_name
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
      cidr = "10.10.2.0/24"
    }
  }
  type = map(object({
    cidr       = string
    delegation = optional(string)
  }))
}
