resource "azurerm_dns_zone" "public" {
  count               = var.create_dns_zone && var.public_dns_zone ? 1 : 0
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "private" {
  count               = var.create_dns_zone && !var.public_dns_zone ? 1 : 0
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "a_records" {
  for_each = { for record in var.a_records : record.name => record }

  name                = each.value.name
  zone_name           = var.public_dns_zone ? azurerm_dns_zone.public[0].name : azurerm_private_dns_zone.private[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}