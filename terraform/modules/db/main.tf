resource "azurerm_mssql_server" "this" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "12.0"

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  public_network_access_enabled        = var.public_network_access_enabled
  minimum_tls_version                  = var.minimum_tls_version
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  tags = var.tags
}
