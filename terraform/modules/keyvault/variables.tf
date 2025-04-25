variable "key_vault_name" {
  description = "Nom unique du Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group dans lequel créer le Key Vault"
  type        = string
}

variable "location" {
  description = "Région Azure pour le Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "ID du tenant Azure AD pour les access policies"
  type        = string
}

variable "sku_name" {
  description = "SKU du Key Vault (standard ou premium)"
  type        = string

  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "enable_rbac_authorization" {
  description = "Utiliser l'authorisation RBAC (true) ou les Access Policies (false)"
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "Durée de rétention (jours) avant soft‑delete"
  type        = number
}

variable "purge_protection_enabled" {
  description = "Activer la purge protection (empêche la purge une fois soft‑deleted)"
  type        = bool
}

variable "public_network_access_enabled" {
  description = "Autoriser l’accès public au vault (false = lock‑down réseau)"
  type        = bool
}

variable "data_plane_principals" {
  description = <<-EOT
Liste des rôles *data‑plane* à créer sur le Key Vault.  
Chaque objet doit contenir :  
- name : identifiant unique pour `for_each`  
- principal_id : Object ID (Service Principal ou Managed Identity)  
- role_definition : nom exact du rôle (ex. "Key Vault Secrets Officer")
EOT
  type = list(object({
    name            = string
    principal_id    = string
    role_definition = string
  }))
  default = []
}


variable "tags" {
  description = "Map de tags à appliquer au Key Vault"
  type        = map(string)
  default     = {}
}