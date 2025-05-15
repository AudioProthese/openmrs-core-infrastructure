resource "kubectl_manifest" "cluster_issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: contact@audioprothese.ovh
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
      - dns01:
          azureDNS:
            managedIdentity:
              clientID: ${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}
            subscriptionID: ${data.azurerm_client_config.current.subscription_id}
            resourceGroupName: ${var.resource_group}
            hostedZoneName: ${azurerm_dns_zone.audioprothese_ovh.name}
            environment: AzurePublicCloud
YAML
}


