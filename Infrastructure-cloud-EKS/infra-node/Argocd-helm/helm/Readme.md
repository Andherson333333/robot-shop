> Spanish version of this README is available as ReadmeES.md

# Robot Shop ArgoCD Configuration
## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [File Structure](#file-structure)
* [Configuration](#configuration)
* [Deployment](#deployment)
* [Access](#access)
* [Verification](#verification)
  
<a name="description"></a>
## General Description
This module implements ArgoCD in the EKS cluster, providing a Continuous Delivery (CD) tool with a web interface accessible through an internal ingress. Being internal, it's only accessible within the VPC.

<a name="prerequisites"></a>
## Prerequisites
- EKS Cluster deployed
- Internal Nginx Ingress Controller configured
- Configured domain (argocd.andherson33.click)
- Terraform >= 1.0
- kubectl
- helm
  
<a name="components"></a>
## Components
The deployment configures:
- ArgoCD in a dedicated namespace
- Ingress for internal access
- Additional ingress for GitHub webhooks
- Secret for GitHub webhook

<a name="file-structure"></a>
## File Structure
```
.
├── templates/
│   └── ingress.yaml   # Template to configure the Kubernetes Ingress resource
├── Chart.yaml         # Helm chart metadata, includes name, version, and dependencies
├── readme.md          # Module documentation
└── values.yaml        # Configurable values to customize the installation
```

<a name="configuration"></a>
## Configuration
### ArgoCD Helm Chart
Configuration:
- Name: argocd
- Repository: argoproj.github.io/argo-helm
- Version: 7.8.13
- Namespace: argocd

### Ingress
Configuration:
- Hostname: argocd.andherson33.click
- Class: nginx-internal
- SSL Redirect: Disabled
- Backend Protocol: HTTP

### Webhook Ingress
Configuration:
- Hostname: argocd.andherson33.click
- Path: /api/webhook
- Class: nginx-external
- SSL Redirect: Disabled
- Backend Protocol: HTTP

### GitHub Webhook
Configuration:
- Secret: "naruto"
- Endpoint: https://argocd.andherson33.click/api/webhook

<a name="deployment"></a>
## Deployment
Update the chart for its dependencies 
```
helm dependency update
```
From outside, you can use a single command to deploy and create the namespace
```
helm install argocd argocd-helm/ --namespace argocd -f argocd-helm/values.yaml --create-namespace
```

<a name="access"></a>
## Access
ArgoCD will be available at:
URL: https://argocd.andherson33.click
To get the initial admin password:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

<a name="verification"></a>
## Verification
### Verify ArgoCD pods
```
kubectl get pods -n argocd
```
### Verify the ingress
```
kubectl get ingress -n argocd
```
### Verify the services
```
kubectl get svc -n argocd
```
### Verify the secrets
```
kubectl get secrets -n argocd
```
- Pod and service
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-1.png)
- Application with working ingress and domain
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-2.png)
- Applications deployed with argocd
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-3.png)
