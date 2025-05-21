#############################
# Cert Manager ClusterIssuer
#############################

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
# OpenMRS Gateway Ingress
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

#############################
# ESO Service Account
#############################

resource "kubectl_manifest" "sa" {
  depends_on = [helm_release.eso]
  yaml_body  = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}"
  name: workload-identity-sa
  namespace: authgate
YAML
}

##############################
# ESO ClusterSecretStore
##############################

resource "kubectl_manifest" "clustersecretstore" {
  depends_on = [kubectl_manifest.sa]
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: azure-secret-store
  namespace: authgate
spec:
  provider:
    azurekv:
      authType: WorkloadIdentity
      vaultUrl: ${azurerm_key_vault.vault.vault_uri}
      tenantId: ${azurerm_key_vault.vault.tenant_id}
      serviceAccountRef:
        name: workload-identity-sa
YAML
}

###############################
# ESO ExternalSecret
###############################

resource "kubectl_manifest" "externalsecret" {
  depends_on = [kubectl_manifest.secretstore]
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: <external-secret-name>
  namespace: authgate
spec:
  refreshPolicy: Periodic
  refreshInterval: 1h 
  secretStoreRef:
    name: azure-secret-store
    kind: SecretStore
  target:
    name: <secret-name-in-k8s>
  data:
  - secretKey: <secret-key-in-k8s>
    remoteRef:
      key: <secret-key-in-azure-key-vault>
YAML
}
