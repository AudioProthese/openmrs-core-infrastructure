resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  tags = var.tags

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions    = ["Create", "Get"]
    secret_permissions = ["Set", "Get", "Delete", "Purge", "Recover"]
  }
}
