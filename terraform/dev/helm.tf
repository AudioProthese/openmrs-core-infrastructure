##########################
# OpenMRS Helm Chart
##########################

resource "helm_release" "openmrs" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "openmrs"
  namespace        = "openmrs"
  repository       = "oci://registry-1.docker.io/openmrs"
  chart            = "openmrs"
  create_namespace = true
  version          = "0.1.5"
  values = [
    "${file("./values/values-openmrs.yaml")}"
  ]
}

##########################
# Prometheus Helm Chart
##########################

resource "helm_release" "prometheus" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "prometheus"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  create_namespace = true
  version          = "27.13.0"
  values = [
    "${file("./values/values-prometheus.yaml")}"
  ]
}

##########################
# Grafana Helm Chart
##########################

resource "helm_release" "grafana" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "grafana"
  namespace        = "monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  create_namespace = true
  version          = "9.0.0"
  values = [
    "${file("./values/values-grafana.yaml")}"
  ]
}

##########################
# Loki Helm Chart
##########################

resource "helm_release" "loki" {
  depends_on       = [azurerm_kubernetes_cluster.aks, kubectl_manifest.sa_loki]
  name             = "loki"
  namespace        = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  create_namespace = true
  version          = "6.29.0"
  values = [
    "${file("./values/values-loki.yaml")}"
  ]
}
