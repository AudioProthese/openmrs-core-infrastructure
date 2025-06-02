##########################
# Variables
##########################

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "openmrs"
}

variable "env" {
  description = "The environment in which the resources will be created"
  type        = string
  default     = "prod"
}

variable "organization" {
  description = "The name of the organization"
  type        = string
  default     = "audioprothese"
}

variable "location" {
  description = "The region in which the resources will be created"
  type        = string
  default     = "France Central"
}

variable "resource_group" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-openmrscore-prod"
}

variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
  default     = "audioprothese.ovh"
}
