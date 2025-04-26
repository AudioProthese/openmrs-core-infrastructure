# 1. Création de la User-Assigned Identity
resource "azurerm_user_assigned_identity" "this" {
  name                = "${var.name_prefix}-uai"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# 2. Assignations de rôles RBAC
resource "azurerm_role_assignment" "this" {
  for_each             = { for r in var.role_assignments : r.name => r }
  scope                = each.value.scope
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = each.value.role_definition_name
}
