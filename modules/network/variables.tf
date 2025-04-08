variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e. g., dev, prod)"
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

variable "vnet_address_space" {
  description = "List of address spaces for the Virtual Network (VNet)"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}