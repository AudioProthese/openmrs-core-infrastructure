# Generic variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Container App Environment configuration
variable "environment" {
  description = "Container App Environment configuration"
  type = object({
    name                           = string
    subnet_id                      = string
    internal_load_balancer_enabled = bool
    logs_destination               = string
    log_analytics_workspace_id     = string
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
    name         = string
    account_name = string
    share_name   = string
    access_key   = string
    access_mode  = string
  })
  sensitive = true
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
    user_assigned_identity_ids = list(string)
    registry = object({
      server      = string
      identity_id = string
    })
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
    omrs_configs   = map(string)
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