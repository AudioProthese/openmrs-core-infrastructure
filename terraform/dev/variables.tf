# variables.tf
# Description: Define the variables used in the project
# Author: Fab

/* General variables */

variable "prj" {
  description = "The name of the project"
  type        = string
  default     = "openmrs-core-infrastructure"
}

variable "org" {
  description = "The name of the organization"
  type        = string
  default     = "sdv"
}

variable "location" {
  description = "The region in which the resources will be created"
  type        = string
  default     = "France Central"
}

/* DNS variables */
variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
  default     = "openmrs.fchevalier.net"
}