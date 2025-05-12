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
  default     = "dev"
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
