> Spanish version of this README is available as ReadmeES.md

# Kiali for Kubernetes
## Index
1. [Description](#description)
2. [Components](#components)
3. [Requirements](#requirements)
4. [Configuration Features](#configuration-features)
5. [Security Considerations](#security-considerations)
6. [Resource Limitations](#resource-limitations)
7. [Access](#access)
8. [File Structure](#file-structure)
9. [Deployment Instructions](#deployment-instructions)
10. [Custom Configuration](#custom-configuration)

## Description
This repository contains the necessary configuration to deploy Kiali, an observability console for Istio Service Mesh in a Kubernetes cluster.

## Components
The configuration includes the following Kubernetes resources:
- **ServiceAccount**: Service account for Kiali
- **ConfigMap**: Kiali configuration
- **ClusterRole**: Cluster-level permissions for Kiali
- **ClusterRoleBinding**: Binds the ClusterRole to the Kiali ServiceAccount
- **Service**: Exposes Kiali within the cluster
- **Deployment**: Deploys Kiali pods
- **Ingress**: Exposes Kiali outside the cluster through `kiali.andherson33.click`

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-1.png)

## Requirements
- Kubernetes 1.19+
- Istio Service Mesh installed
- Prometheus (configured for monitoring)
- Grafana (optional, for additional dashboards)
- NGINX Ingress Controller

## Configuration Features
- Deploys Kiali v2.0
- Configured to run on infrastructure nodes
- Anonymous authentication
- Integration with Prometheus at `http://prometheus-operator-kube-p-prometheus.monitoring:9090`
- Integration with Grafana at `http://prometheus-operator-grafana.monitoring:80`
- Exposure through Ingress with the name `kiali.andherson33.click`

## Security Considerations
- Runs Kiali with minimal privileges
- Does not inject the Istio sidecar (`sidecar.istio.io/inject: "false"`)
- Uses `readOnlyRootFilesystem: true` and other security practices

## Resource Limitations
```yaml
resources:
  limits:
    memory: 1Gi
  requests:
    cpu: 10m
    memory: 64Mi
```

## Access
Once deployed, Kiali will be available at:
- URL: `https://kiali.andherson33.click`
- Internal port: 20001
- Base path: `/kiali`

## File Structure
- `kiali.yaml`: Main Kiali definition (ServiceAccount, ConfigMap, ClusterRole, ClusterRoleBinding, Service, Deployment)
- `kiali-ingress.yaml`: Ingress configuration for external access

## Deployment Instructions
1. Make sure you have the `istio-system` namespace:
```bash
kubectl apply -f argocd-kiali.yml
```

## Verification
4. Verify the deployment:
```bash
kubectl get pods -n istio-system | grep kiali
kubectl get ingress -n istio-system
```

- Pod and services 
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-2.png)
- Verification of connection with Grafana and Prometheus (with ingress activated)
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-3.png)
- ArgoCD UI
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-4.png)
- Operation with robot-shop 
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-5.png)

## Custom Configuration
To modify the configuration, edit the ConfigMap in `kiali.yaml`. Some common values to customize:
- Authentication strategy
- Prometheus URL
- Grafana URL
- Number of replicas
- Allocated resources
