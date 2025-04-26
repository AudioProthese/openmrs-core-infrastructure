resource "azurerm_key_vault" "this" {
  name                      = var.key_vault_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  tenant_id                 = var.tenant_id
  sku_name                  = var.sku_name
  enable_rbac_authorization = var.enable_rbac_authorization
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

resource "azurerm_role_assignment" "data_plane" {
  for_each             = { for p in var.data_plane_principals : p.name => p }
  scope                = azurerm_key_vault.this.id
  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition
}