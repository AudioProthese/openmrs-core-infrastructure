<img src="https://raw.githubusercontent.com/AudioProthese/.github/refs/heads/main/profile/icon.jpeg" align="right" height="96"/>

# AudioProthese + Core Infrastructure

![Terraform Version](https://img.shields.io/badge/terraform-v1.11.3-purple?logo=terraform)
![License](https://img.shields.io/badge/license-GPLv3-blue)
![GitHub Workflow Status](https://github.com/AudioProthese/openrms-core-infrastructure/actions/workflows/terraform-apply-dev.yml/badge.svg)

*This Git repository contains the source code to set up and manage AudioProthese+ infrastructure using Terraform.*

## AZ CLI to init backend

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
  name: openmrs-gateway-ingress
  namespace: openmrs  # Namespace for your openmrs app
spec:
  ingressClassName: webapprouting.kubernetes.azure.com  # Azure-specific ingress class
  rules:
    - host: openmrs.audioprothese.duckdns.org  # Replace with your domain
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: gateway  # The service name of your openmrs gateway
                port:
                  number: 80   # Port where your service is exposed
```

```bash
# apply ingress manifest
kubectl apply -f ingress.yaml
```

## Grafana dashboard

- [kubernetes cluster](https://grafana.com/grafana/dashboards/12202-kubernetes-cluster-overview/)
- [Prometheus](https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/)