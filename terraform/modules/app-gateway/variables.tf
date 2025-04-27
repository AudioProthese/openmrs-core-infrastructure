variable "name" {
  description = "Préfixe de nom pour l'App Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "subnet_id" {
  description = "ID du subnet dédié à l'App Gateway"
  type        = string
}

variable "sku_name" {
  description = "Nom du SKU (Standard_v2, WAF_v2)"
  type        = string
  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_name)
    error_message = "sku_name must be one of Standard_v2 or WAF_v2"
  }
}

variable "sku_tier" {
  description = "Tier du SKU (Standard_v2, WAF_v2)"
  type        = string
  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_tier)
    error_message = "sku_tier must be one of Standard_v2 or WAF_v2"
  }
}

variable "sku_capacity" {
  description = "Nombre d'instances de l'App Gateway"
  type        = number
}

variable "frontend_port" {
  description = "Port HTTP d'écoute"
  type        = number
}

variable "gateway_ip_config_name" {
  description = "Nom de la configuration IP interne"
  type        = string
}

variable "frontend_ip_config_name" {
  description = "Nom de la configuration IP publique"
  type        = string
}

variable "frontend_port_name" {
  description = "Nom du port frontal"
  type        = string
}

variable "backend_pool_name" {
  description = "Nom du pool d'adresses backend"
  type        = string
}

variable "http_setting_name" {
  description = "Nom du HTTP setting"
  type        = string
}

variable "listener_name" {
  description = "Nom du listener"
  type        = string
}

variable "rule_name" {
  description = "Nom de la règle de routage"
  type        = string
}

variable "backend_addresses" {
  description = "Liste d'objets { ip_address?, fqdn? } pour le pool backend"
  type = list(object({
    ip_address = optional(string)
    fqdn       = optional(string)
  }))
}

variable "tags" {
  description = "Map de tags à appliquer"
  type        = map(string)
}

variable "backend_port" {
  description = "Port to use for backend HTTP settings"
  type        = number
}