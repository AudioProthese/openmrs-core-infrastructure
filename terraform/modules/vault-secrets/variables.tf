variable "key_vault_id" {
  description = "ID du Key Vault"
  type        = string
}

variable "secrets" {
  description = "Map de noms → valeurs de secrets à créer"
  type        = map(string)
}