##########################
# Providers Definition
##########################

terraform {
  required_version = "= 1.11.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "=1.14.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-openmrscore-dev"
    storage_account_name = "openmrscoredevsa01"
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

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  load_config_file       = false
}
