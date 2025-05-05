# Terraform version
terraform {
  required_version = ">= 1.6.6"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.25.0, <=4.27.0"
    }
  }
}