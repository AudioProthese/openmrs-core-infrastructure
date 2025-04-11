variable "zone_name" {
  description = "Name of the DNS zone (e.g., example.com)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "create_dns_zone" {
  description = "Whether to create a new DNS zone (true) or use existing (false)"
  type        = bool
  default     = true
}

variable "public_dns_zone" {
  description = "Create a public DNS zone (true) or private DNS zone (false)"
  type        = bool
  default     = true
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