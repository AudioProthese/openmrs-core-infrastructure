resource "kubectl_manifest" "sa_loki" {
  depends_on = [helm_release.loki]
  yaml_body  = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}"
  labels:
    "azure.workload.identity/use": "true"
  name: loki
  namespace: loki
YAML
}
