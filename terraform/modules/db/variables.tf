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
  description = "Autoriser l'accès public au serveur SQL"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Version TLS minimale (1.0, 1.1, 1.2, 1.3)"
  type        = string
  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of 1.0, 1.1, 1.2 or 1.3."
  }
}

variable "outbound_network_restriction_enabled" {
  description = "Restreindre le trafic sortant du serveur SQL"
  type        = bool
}

variable "identity_type" {
  description = "Type d'identité Managed Identity (SystemAssigned, UserAssigned, ou les deux)"
  type        = string
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type)
    error_message = "identity_type must be 'SystemAssigned', 'UserAssigned' or 'SystemAssigned,UserAssigned'."
  }
}

variable "identity_ids" {
  description = "Liste d'IDs de User Assigned Managed Identities"
  type        = list(string)
}

variable "tags" {
  description = "Tags à appliquer aux ressources SQL"
  type        = map(string)
}

# Database-specific settings

variable "database_name" {
  description = "Nom de la base de données"
  type        = string
}

variable "collation" {
  description = "Collation de la base de données"
  type        = string
}

variable "license_type" {
  description = "Type de licence (LicenseIncluded ou BasePrice)"
  type        = string
  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "license_type must be either 'LicenseIncluded' or 'BasePrice'."
  }
}

variable "max_size_gb" {
  description = "Taille max de la base (en GB)"
  type        = number
}

variable "read_scale_enabled" {
  description = "Activer la réplication en lecture seule"
  type        = bool
}

variable "sku_name" {
  description = "SKU de la base (Basic, S0, S1, … P15)"
  type        = string
}

variable "zone_redundant" {
  description = "Activer la redondance zonale"
  type        = bool
}

variable "backup_retention_days" {
  description = "Rétention des backups PITR (7–35 jours)"
  type        = number
  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "backup_retention_days must be between 7 and 35."
  }
}
