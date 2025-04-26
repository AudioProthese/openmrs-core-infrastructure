resource "azurerm_key_vault_secret" "this" {
  for_each     = var.secrets
  name         = replace(each.key, "_", "-")
  value        = each.value
  key_vault_id = var.key_vault_id
  depends_on   = [var.key_vault_id]
}