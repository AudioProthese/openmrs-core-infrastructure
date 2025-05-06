# Variables générales
variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "tags" {
  description = "Tags pour les ressources"
  type        = map(string)
}

# Variables Log Analytics
variable "log_analytics_workspace_name" {
  description = "Nom de l'espace de travail Log Analytics"
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU de l'espace de travail Log Analytics"
  type        = string
}

variable "log_retention_days" {
  description = "Nombre de jours de rétention des logs"
  type        = number
}

# Variables Storage Account
variable "storage_account_name" {
  description = "Nom du compte de stockage"
  type        = string
}

variable "storage_account_tier" {
  description = "Tier du compte de stockage"
  type        = string
}

variable "storage_replication_type" {
  description = "Type de réplication du stockage"
  type        = string
}

# Variables File Share
variable "openrms_fileshare_name" {
  description = "Nom du partage de fichiers pour openrms"
  type        = string
}

variable "openrms_fileshare_quota" {
  description = "Quota en GB pour le partage de fichiers openrms"
  type        = number
}
