variable "zone_name" {
  description = "Name of the DNS zone (e.g., example.com)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "a_records" {
  description = "List of A records to create"
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
}