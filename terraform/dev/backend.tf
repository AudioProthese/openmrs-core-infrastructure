# Description: Terraform configuration file for the dev environment
# Author: Lthat

terraform {
  required_version = ">= 1.8.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.25.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.7.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-openrmscore-dev"
    storage_account_name = "openrmscoredevsa01"
    container_name       = "tfstate-dev"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "random" {
}