variable "resource_group_name" {
  description = "Name of the resource group (provided by root module)"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created (provided by root module)"
  type        = string
}

variable "container_app_environment_name" {
  description = "Name of the Container App Environment (provided by root module)"
  type        = string
}

variable "container_app_name" {
  description = "Name of the Container App (provided by root module)"
  type        = string
}

variable "aca_subnet_id" {
  description = "ID of the subnet for Container App Environment (provided by network module)"
  type        = string
}

variable "internal_load_balancer_enabled" {
  description = "Whether to enable internal load balancer (provided by root module)"
  type        = bool
}

variable "logs_destination" {
  description = "Destination for logs (provided by root module)"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace (provided by monitoring module)"
  type        = string
}

variable "revision_mode" {
  description = "Revision mode for the Container App (provided by root module)"
  type        = string
}

variable "min_replicas" {
  description = "Minimum number of replicas (provided by root module)"
  type        = number
}

variable "max_replicas" {
  description = "Maximum number of replicas (provided by root module)"
  type        = number
}

# Frontend container variables
variable "enable_frontend" {
  description = "Whether to enable the frontend container (provided by root module)"
  type        = bool
}

variable "container_image_frontend" {
  description = "Docker image for the frontend container (provided by root module)"
  type        = string
}

variable "cpu_frontend" {
  description = "CPU allocation for the frontend container (provided by root module)"
  type        = string
}

variable "memory_frontend" {
  description = "Memory allocation for the frontend container (provided by root module)"
  type        = string
}

variable "frontend_env_vars" {
  description = "Environment variables for frontend container (provided by root module)"
  type        = map(string)
}

# Backend container variables
variable "enable_backend" {
  description = "Whether to enable the backend container (provided by root module)"
  type        = bool
}

variable "container_image_backend" {
  description = "Docker image for the backend container (provided by root module)"
  type        = string
}

variable "cpu_backend" {
  description = "CPU allocation for the backend container (provided by root module)"
  type        = string
}

variable "memory_backend" {
  description = "Memory allocation for the backend container (provided by root module)"
  type        = string
}

variable "omrs_configs" {
  description = "OpenMRS configuration values (provided by root module)"
  type        = map(string)
}

variable "enable_backend_volume" {
  description = "Whether to enable volume for the backend container (provided by root module)"
  type        = bool
}

variable "backend_volume_path" {
  description = "Path to mount the volume in the backend container (provided by root module)"
  type        = string
}

# Gateway container variables
variable "enable_gateway" {
  description = "Whether to enable the gateway container (provided by root module)"
  type        = bool
}

variable "container_image_gateway" {
  description = "Docker image for the gateway container (provided by root module)"
  type        = string
}

variable "cpu_gateway" {
  description = "CPU allocation for the gateway container (provided by root module)"
  type        = string
}

variable "memory_gateway" {
  description = "Memory allocation for the gateway container (provided by root module)"
  type        = string
}

variable "gateway_env_vars" {
  description = "Environment variables for gateway container (provided by root module)"
  type        = map(string)
}

# Storage variables
variable "storage_type" {
  description = "Type of storage for volumes (provided by root module)"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account (provided by monitoring module)"
  type        = string
}

# Ingress variables
variable "enable_ingress" {
  description = "Whether to enable ingress (provided by root module)"
  type        = bool
}

variable "ingress_external_enabled" {
  description = "Whether to enable external ingress (provided by root module)"
  type        = bool
}

variable "target_port" {
  description = "Target port for ingress (provided by root module)"
  type        = number
}

variable "ingress_transport" {
  description = "Transport protocol for ingress (provided by root module)"
  type        = string
}

variable "traffic_weights" {
  description = "Traffic weights configuration (provided by root module)"
  type = list(object({
    latest_revision = bool
    revision_suffix = optional(string)
    percentage      = number
  }))
}

# Identity and registry variables
variable "user_assigned_identity_ids" {
  description = "List of user assigned identity IDs (provided by identity module)"
  type        = list(string)
}

variable "registry_server" {
  description = "Container registry server (provided by ACR module)"
  type        = string
}

variable "registry_identity_id" {
  description = "Identity ID for registry authentication (provided by identity module)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources (provided by root module)"
  type        = map(string)
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