resource "kubectl_manifest" "sa" {
  depends_on = [helm_release.eso]
  yaml_body  = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}"
  name: workload-identity-sa
  namespace: default
YAML
}

resource "kubectl_manifest" "secretstore" {
  depends_on = [kubectl_manifest.sa]
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: azure-secret-store
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

resource "kubectl_manifest" "externalsecret" {
  depends_on = [kubectl_manifest.secretstore]
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-secret
spec:
  refreshInterval: 30s
  secretStoreRef:
    name: azure-secret-store
    kind: SecretStore
  target:
    name: open-mrs-secret
  data:
  - secretKey: OMRS_CONFIG_MODULE_WEB_ADMIN
    remoteRef:
      key: OMRS_CONFIG_MODULE_WEB_ADMIN
  - secretKey: OMRS_CONFIG_AUTO_UPDATE_DATABASE
    remoteRef:
      key: OMRS_CONFIG_AUTO_UPDATE_DATABASE
  - secretKey: OMRS_CONFIG_CREATE_TABLES
    remoteRef:
      key: OMRS_CONFIG_CREATE_TABLES
  - secretKey: replication-password
    remoteRef:
      key: pg-replication-password
  - secretKey: mysql-root-password
    remoteRef:
      key: mysql-root-password
  - secretKey:  mysql-password
    remoteRef:
      key:  mysql-password
  - secretKey: mysql-replication-password
    remoteRef:
      key: mysql-replication-password
YAML
}
