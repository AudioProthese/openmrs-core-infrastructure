# # Create the namespace
# resource "kubectl_manifest" "namespace_loki" {
#   yaml_body = <<YAML
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: loki
# YAML
# }

# # Create the ServiceAccount
# resource "kubectl_manifest" "sa_loki" {
#   depends_on = [kubectl_manifest.namespace_loki]
#   yaml_body  = <<YAML
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   annotations:
#     azure.workload.identity/client-id: "${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}"
#   labels:
#     "azure.workload.identity/use": "true"
#   name: loki
#   namespace: loki
# YAML
# }
