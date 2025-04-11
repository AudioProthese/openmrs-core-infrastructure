resource "azurerm_dns_zone" "public" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "a_records" {
  for_each = { for record in var.a_records : record.name => record }

  name                = each.value.name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}