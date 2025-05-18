<img src="https://raw.githubusercontent.com/AudioProthese/.github/refs/heads/main/profile/icon.jpeg" align="right" height="96"/>

# AudioProthese + Core Infrastructure

![Terraform Version](https://img.shields.io/badge/terraform-v1.11.3-purple?logo=terraform)
![License](https://img.shields.io/badge/license-GPLv3-blue)
![GitHub Workflow Status](https://github.com/AudioProthese/openrms-core-infrastructure/actions/workflows/terraform-apply-dev.yml/badge.svg)

*This Git repository contains the source code to set up and manage AudioProthese+ infrastructure using Terraform.*

## AZ CLI to create a Service Principal with Federated Credential

- [docs](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)

```bash
az ad app create --display-name "gh-terraform-sp"
az ad app list --display-name "gh-terraform-sp" --query "[0].{appId:appId, objectId:id}" -o json
az ad sp create --id <app_id>

az role assignment create \
  --assignee <app_id> \
  --role "Contributor" \
  --scope /subscriptions/c2b90606-cc96-463f-aa06-70f32719fe4f

az ad app federated-credential create --id <app_id> --parameters @federated-credential.json
```


## AZ CLI to init backend & tf service principal

- [docs](https://learn.microsoft.com/fr-fr/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

```bash
#!/bin/bash

RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstate$RANDOM
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location francecentral

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
```

## CI/CD Variables

```bash
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

## Helm charts

- [OpenMRS](https://github.com/openmrs/openmrs-contrib-cluster)
- [Grafana](https://artifacthub.io/packages/helm/grafana/grafana)
- [Prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

## Ingress openmrs gateway 

- Create duckdns name
- Point record to web app routing IP
- Deploy with CI
- Issue with helm chart openmrs gateway dont handle host in ingress so need to deploy ingress manually ATM

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: le-prod
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  name: openmrs-gateway-ingress
  namespace: openmrs
spec:
  ingressClassName: webapprouting.kubernetes.azure.com
  rules:
    - host: openmrs.dev.audioprothese.toxma.fr
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: gateway
                port:
                  number: 80
  tls: []
    - secretName: openmrs-tls
      hosts:
        - openmrs.dev.audioprothese.toxma.fr
```

```bash
# apply ingress manifest
kubectl apply -f ingress.yaml
```

## Grafana dashboard

- [kubernetes cluster](https://grafana.com/grafana/dashboards/12202-kubernetes-cluster-overview/)
- [Prometheus](https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/)



# Middleware d’authentification Zero Trust pour Prometheus (Azure AKS)

## 🛡️ Pourquoi ce setup ?

Dans une logique **Zero Trust**, chaque accès à une application sensible doit être authentifié, même en interne.  
Beaucoup d’outils comme **Prometheus** n’ont pas de gestion d’utilisateurs native ou d’intégration SSO d’entreprise (Azure AD, Google, etc).  
Pour répondre à ce besoin de sécurité et d’unification de l’authentification :

- On utilise **Web App Routing** (NGINX managé par Azure) pour centraliser les accès HTTP/HTTPS.
- On place un **middleware d’authentification** devant l’application : **OAuth2 Proxy**.

## 🔗 Le rôle du middleware OAuth2 Proxy

- **OAuth2 Proxy** agit comme un “garde du corps” devant Prometheus.
- Il intercepte toute requête HTTP(s) arrivant à l’application.
- S’il n’y a pas de session authentifiée, il force une authentification SSO via **Azure Active Directory** (OpenID Connect).
- Après validation, il redirige l’utilisateur vers Prometheus, tout en gardant l’accès protégé (Zero Trust appliqué).
- Les sessions sont stockées côté serveur (ici Redis), ce qui évite les gros cookies et sécurise le processus.

## 🏗️ Pourquoi ce schéma Zero Trust est pertinent ?

- **Prometheus n’a pas de SSO** → on ne veut pas exposer ses dashboards à tout le monde.
- On veut **unifier l’accès** (un seul login pour tout l’écosystème d’entreprise).
- On évite de modifier Prometheus ou de patcher le code : l’intégration est “transparent reverse proxy”.

## 🦾 Comment ça marche pour l’utilisateur ?

1. L’utilisateur tente d’accéder à `https://prometheus.dev.audioprothese.ovh`.
2. **NGINX (Web App Routing)** vérifie via les annotations si la requête est authentifiée (appelle `/oauth2/auth`).
3. **OAuth2 Proxy** vérifie la session (cookie + Redis).  
   - S’il n’y a pas de session, il renvoie vers la page de login Azure AD.
   - Sinon, il laisse passer.
4. Après login, l’utilisateur arrive sur Prometheus