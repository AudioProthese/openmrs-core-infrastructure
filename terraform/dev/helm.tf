resource "helm_release" "eso" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  name             = "external-secrets"
  namespace        = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = true
  version          = "0.10.5"
}
