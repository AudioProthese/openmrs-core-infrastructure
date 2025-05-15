##########################
# OpenMRS Helm Chart
##########################

resource "helm_release" "openmrs" {
  provider         = helm.aks
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "openmrs"
  namespace        = "openmrs"
  repository       = "oci://registry-1.docker.io/openmrs"
  chart            = "openmrs"
  create_namespace = true
  version          = "0.1.5"
  upgrade_install  = true
  values = [
    "${file("./values/openmrs-values.yaml")}"
  ]
}

##########################
# Prometheus Helm Chart
##########################

resource "helm_release" "prometheus-stack" {
  provider         = helm.aks
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "prometheus-stack"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  version          = "72.3.1"
  upgrade_install  = true
  values = [
    "${file("./values/prometheus-stack-values.yaml")}"
  ]
}

##########################
# Loki Helm Chart
##########################

resource "helm_release" "loki" {
  provider         = helm.aks
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "loki"
  namespace        = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  create_namespace = true
  version          = "6.29.0"
  upgrade_install  = true
  values = [
    "${file("./values/loki-values.yaml")}"
  ]
}

##########################
# Alloy Helm Chart
##########################

resource "helm_release" "alloy" {
  provider         = helm.aks
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "alloy"
  namespace        = "alloy"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "alloy"
  create_namespace = true
  version          = "1.0.3"
  upgrade_install  = true
  values = [
    "${file("./values/alloy-values.yaml")}"
  ]
}

#############################
# Cert Manager Helm Chart
#############################

resource "helm_release" "cert_manager" {
  provider         = helm.aks
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  version          = "v1.17.2"
  upgrade_install  = true
}
