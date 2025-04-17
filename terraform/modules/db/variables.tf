variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "server_name" {
  description = "Nom unique du serveur SQL"
  type        = string
}

variable "administrator_login" {
  description = "Login administrateur SQL"
  type        = string
}

variable "administrator_login_password" {
  description = "Mot de passe administrateur SQL"
  type        = string
  sensitive   = true
}

variable "public_network_access_enabled" {
  description = "Autoriser l'accès public"
  type        = bool
}

variable "minimum_tls_version" {
  description = "Version TLS minimale"
  type        = string
}

variable "outbound_network_restriction_enabled" {
  description = "Restreindre le trafic sortant"
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Type d'identité Managed Identity (SystemAssigned, UserAssigned, etc.)"
  type        = string
}

variable "identity_ids" {
  description = "Liste d'IDs de User Assigned Managed Identities"
  type        = list(string)
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
}