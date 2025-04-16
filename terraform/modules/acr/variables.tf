variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group where the ACR will be deployed."
}

variable "location" {
  type        = string
  description = "Azure location for the ACR (e.g., 'West Europe')."
}

variable "sku" {
  type        = string
  description = "SKU of the ACR. Options: Basic, Standard, Premium."
}

variable "tags" {
  type        = map(string)
  description = "Tags to associate with the ACR."
}
