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

##########################
# OpenMRS Ingress
##########################

resource "kubectl_manifest" "openmrs_ingress" {
  depends_on = [helm_release.openmrs]
  yaml_body  = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  name: openmrs-gateway-ingress
  namespace: openmrs
spec:
  ingressClassName: webapprouting.kubernetes.azure.com
  rules:
    - host: openmrs.dev.audioprothese.ovh
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: gateway
                port:
                  number: 80
  tls:
    - secretName: openmrs-tls
      hosts:
        - openmrs.dev.audioprothese.ovh
YAML
}



