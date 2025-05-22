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
    "${file("./values/openmrs-values.yaml")}"
  ]
}

##########################
# Prometheus Helm Chart
##########################

resource "helm_release" "prometheus-stack" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "prometheus-stack"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  version          = "72.3.1"
  values = [
    "${file("./values/prometheus-stack-values.yaml")}"
  ]
}

##########################
# Loki Helm Chart
##########################

resource "helm_release" "loki" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "loki"
  namespace        = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  create_namespace = true
  version          = "6.29.0"
  values = [
    "${file("./values/loki-values.yaml")}"
  ]
}

##########################
# Alloy Helm Chart
##########################

resource "helm_release" "alloy" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "alloy"
  namespace        = "alloy"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "alloy"
  create_namespace = true
  version          = "1.0.3"
  values = [
    "${file("./values/alloy-values.yaml")}"
  ]
}

#############################
# Cert Manager Helm Chart
#############################

resource "helm_release" "cert_manager" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  version          = "v1.17.2"
  values = [
    "${file("./values/cert-manager-values.yaml")}"
  ]
}

#############################
# ArgoCD Helm Chart
#############################

resource "helm_release" "argocd" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  version          = "8.0.3"
  values = [
    "${file("./values/argocd-values.yaml")}"
  ]
}

#############################
# Oauth2-proxy Helm Chart
#############################

resource "helm_release" "oauth2_proxy" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "oauth2-proxy"
  namespace        = "authgate"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  create_namespace = true
  version          = "7.12.13"
  values = [
    file("./values/oauth2-proxy-values.yaml")
  ]
}

# ESO Helm Chart
#############################

resource "helm_release" "eso" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "eso"
  namespace        = "eso"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = true
  version          = "0.17.0"

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = "workload-identity-sa"
      }
    })
  ]
}
