<img src="https://raw.githubusercontent.com/AudioProthese/.github/refs/heads/main/profile/icon.jpeg" align="right" height="96"/>

# AudioProthese + Core Infrastructure

![Terraform Version](https://img.shields.io/badge/terraform-v1.11.3-purple?logo=terraform)
![License](https://img.shields.io/badge/license-GPLv3-blue)
![GitHub Workflow Status](https://github.com/AudioProthese/openrms-core-infrastructure/actions/workflows/terraform-apply-dev.yml/badge.svg)

*This Git repository contains the source code to set up and manage AudioProthese+ infrastructure using Terraform.*

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