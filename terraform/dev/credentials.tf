resource "random_password" "sql_admin" {
  length           = 16
  special          = true
  override_special = "!@#%&*()-_=+<>?/"
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [module.keyvault]
}