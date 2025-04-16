variable "project_name" {
  description = "Name of the project"
  type        = string
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}