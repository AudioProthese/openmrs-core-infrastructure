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
