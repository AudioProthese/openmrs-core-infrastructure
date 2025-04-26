variable "name_prefix" {
  description = "Préfixe de nom pour l’UAI"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "role_assignments" {
  description = <<-EOT
Liste des rôles RBAC à assigner à l’UAI.  
Chaque objet doit contenir :
- name : identifiant unique pour for_each  
- scope : ID de la ressource (module.acr.acr_id, module.keyvault.key_vault_id, …)  
- role_definition_name : nom du rôle built-in (e.g. "AcrPull", "Key Vault Secrets User")
EOT
  type = list(object({
    name                 = string
    scope                = string
    role_definition_name = string
  }))
  default = []
}
