##########################
# Providers Definition
##########################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-openrmscore-dev"
    storage_account_name = "openrmscoredevsa01"
    container_name       = "tfstate-dev"
    key                  = "terraform.tfstate"
  }
}

##########################
# Providers Configuration
##########################

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}
