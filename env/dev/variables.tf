variable "project_name" {
  default = "openrmscore"
}

variable "environment" {
  default = "dev"
}

variable "location" {
  default = "francecentral"
}

variable "resource_group_name" {
  default = "rg-openrmscore-dev"
}

variable "vnet_address_space" {
  default = ["10.10.0.0/16"]
}
