variable "server_name" {
  description = "Nom du serveur MySQL"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "database_name" {
  description = "Nom de la base de données OpenMRS"
  type        = string
}

variable "administrator_login" {
  description = "Nom d'utilisateur administrateur pour MySQL"
  type        = string
}

variable "administrator_login_password" {
  description = "Mot de passe administrateur pour MySQL"
  type        = string
  sensitive   = true
}

variable "backup_retention_days" {
  description = "Nombre de jours de rétention des sauvegardes"
  type        = number
}

variable "sku_name" {
  description = "Niveau de performance du serveur MySQL"
  type        = string
}

variable "max_size_gb" {
  description = "Taille maximale du stockage en GB"
  type        = number
  default     = 20
}

variable "public_network_access_db" {
  description = "Autoriser l'accès public au serveur MySQL"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
}