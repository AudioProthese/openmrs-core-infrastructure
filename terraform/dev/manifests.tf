# #############################
# # Cert Manager ClusterIssuer
# #############################

# resource "kubectl_manifest" "cluster_issuer" {
#   depends_on = [helm_release.cert_manager]
#   yaml_body  = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-prod
#   namespace: cert-manager
# spec:
#   acme:
#     server: https://acme-v02.api.letsencrypt.org/directory
#     email: contact@audioprothese.ovh
#     privateKeySecretRef:
#       name: letsencrypt-production
#     solvers:
#       - dns01:
#           azureDNS:
#             managedIdentity:
#               clientID: ${azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id}
#             subscriptionID: ${data.azurerm_client_config.current.subscription_id}
#             resourceGroupName: ${var.resource_group}
#             hostedZoneName: ${azurerm_dns_zone.audioprothese_ovh.name}
#             environment: AzurePublicCloud
# YAML
# }

# ##########################
# # OpenMRS Gateway Ingress
# ##########################

# resource "kubectl_manifest" "openmrs_ingress" {
#   depends_on = [helm_release.openmrs]
#   yaml_body  = <<YAML
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   annotations:
#     cert-manager.io/cluster-issuer: letsencrypt-prod
#     nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
#   name: openmrs-gateway-ingress
#   namespace: openmrs
# spec:
#   ingressClassName: webapprouting.kubernetes.azure.com
#   rules:
#     - host: openmrs.dev.audioprothese.ovh
#       http:
#         paths:
#           - path: /
#             pathType: Prefix
#             backend:
#               service:
#                 name: gateway
#                 port:
#                   number: 80
#   tls:
#     - secretName: openmrs-tls
#       hosts:
#         - openmrs.dev.audioprothese.ovh
# YAML
# }

# ##############################
# # ESO ClusterSecretStore
# ##############################

# resource "kubectl_manifest" "cluster_secretstore" {
#   depends_on = [helm_release.eso]
#   yaml_body  = <<YAML
# apiVersion: external-secrets.io/v1
# kind: ClusterSecretStore
# metadata:
#   name: azure-secret-store
# spec:
#   provider:
#     azurekv:
#       authType: WorkloadIdentity
#       vaultUrl: ${azurerm_key_vault.vault.vault_uri}
#       tenantId: ${azurerm_key_vault.vault.tenant_id}
#       serviceAccountRef:
#         name: workload-identity-sa
#         namespace: eso
# YAML
# }

# ###############################
# # ESO ExternalSecret
# ###############################

# resource "kubectl_manifest" "externalsecret" {
#   depends_on = [helm_release.eso, heml_release.oauth2_proxy]
#   yaml_body  = <<YAML
# apiVersion: external-secrets.io/v1
# kind: ExternalSecret
# metadata:
#   name: oauth2-proxy-secret
#   namespace: authgate
# spec:
#   refreshPolicy: Periodic
#   refreshInterval: 1h
#   secretStoreRef:
#     name: azure-secret-store
#     kind: ClusterSecretStore
#   target:
#     name: oauth2-proxy-secret
#     creationPolicy: Owner
#   data:
#   - secretKey: client-id
#     remoteRef:
#       key: oauth2-proxy-client-id
#   - secretKey: client-secret
#     remoteRef:
#       key: oauth2-proxy-client-secret
#   - secretKey: cookie-secret
#     remoteRef:
#       key: oauth2-proxy-cookie-secret
# YAML
# }

# ###############################
# # Telegram Alertmanager Secret
# ###############################

# resource "kubectl_manifest" "telegram_secret" {
#   depends_on = [helm_release.eso, helm_release.prometheus]
#   yaml_body  = <<YAML
# apiVersion: external-secrets.io/v1
# kind: ExternalSecret
# metadata:
#   name: telegram-alertmanager-secret
#   namespace: monitoring
# spec:
#   refreshPolicy: Periodic
#   refreshInterval: 1h
#   secretStoreRef:
#     name: azure-secret-store
#     kind: ClusterSecretStore
#   target:
#     name: telegram-alertmanager-secret
#     creationPolicy: Owner
#   data:
#   - secretKey: telegram_bot_token
#     remoteRef:
#       key: telegram-bot-token
#   - secretKey: telegram_chat_id
#     remoteRef:
#       key: telegram-chat-id
# YAML
# }
