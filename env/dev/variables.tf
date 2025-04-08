variable "project_name" {
  description = "Name of the project"
  default     = "openrmscore"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
}

variable "location" {
  description = "Azure location"
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  default     = "rg-openrmscore-dev"
}

variable "vnet_address_space" {
  description = "List of address spaces for the Virtual Network (VNet)"
  default     = ["10.10.0.0/16"]
}
