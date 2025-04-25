# network/variables.tf

variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement (dev, prod, …)"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "vnet_address_space" {
  description = "Liste des plages d’adresses pour le VNet"
  type        = list(string)
}

variable "subnets" {
  description = <<-EOT
Map des subnets :
- clé : suffixe nommage
- value.cidr       = CIDR (ex. "10.0.1.0/24")
- value.delegation = (optionnel) nom de la délégation de service
EOT
  type = map(object({
    cidr       = string
    delegation = optional(string)
  }))
}

variable "nsg_rules" {
  description = <<-EOT
(Réglable par subnet) map où la clé est le même suffixe que dans `subnets`, et la value est
une liste d’objets NSG rules :
  - name
  - priority
  - direction        (Inbound/Outbound)
  - access           (Allow/Deny)
  - protocol         (*, Tcp, Udp)
  - source_port_range
  - destination_port_range
  - source_address_prefix
  - destination_address_prefix
EOT
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })))
  default = {}
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
  default     = {}
}
