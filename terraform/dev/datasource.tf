data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "db_admin_password" {
  name         = "sql-admin-password"
  key_vault_id = module.keyvault.key_vault_id
}