variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement (ex: dev, prod)"
  type        = string
}

variable "location" {
  description = "Emplacement Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "vnet_address_space" {
  description = "Liste des plages d’adresses du VNet"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}