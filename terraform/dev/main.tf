module "network" {
  source              = "../../modules/network"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
}

module "acr" {
  source = "../../modules/acr"
  acr_name            = "${var.project_name}${var.environment}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  tags = {
    environment = var.environment
    project     = var.project_name
  }
}
