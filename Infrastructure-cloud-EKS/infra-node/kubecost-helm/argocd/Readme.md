> Spanish version of this README is available as ReadmeES.md

# Kubecost Helm Configuration
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
This module implements Kubecost in the Kubernetes cluster using Helm, providing a cost analysis and visibility tool to monitor and optimize expenses related to Kubernetes infrastructure.

<a name="prerequisites"></a>
## Prerequisites
- Functioning Kubernetes cluster
- Nginx Ingress Controller configured
- Configured domain (kubecost.andherson33.click)
- Helm v3 installed
- kubectl configured to access the cluster
- Prometheus installed

<a name="components"></a>
## Components
The deployment configures:
- Kubecost Cost Analyzer in a dedicated namespace
- Integration with existing Prometheus
- Kubecost frontend
- Integrated Grafana
- Ingress for external access
- Optimized resource configuration

<a name="file-structure"></a>
## File Structure
```
.
├── templates/
│   └── ingress.yaml   # Template to configure Kubecost Ingress
├── Chart.yaml         # Helm chart metadata, includes name, version, and dependencies
├── readme.md          # Module documentation
└── values.yaml        # Configurable values to customize the installation
```

<a name="configuration"></a>
## Configuration
### Kubecost Helm Chart
Configuration:
- Name: kubecost
- Chart Version: 0.1.0
- App Version: 2.7.0
- Dependency: cost-analyzer 2.7.0
- Repository: https://kubecost.github.io/cost-analyzer/

### Prometheus Integration
Configuration:
- Prometheus enabled: false (uses an existing instance)
- FQDN: http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090
- Grafana enabled: true

### Resources
Configuration:
- Kubecost Model Requests:
  - CPU: 200m
  - Memory: 512Mi
- Kubecost Model Limits:
  - CPU: 800m
  - Memory: 1Gi
- Readiness Probe: 120s initialDelay
- Liveness Probe: 120s initialDelay

### Ingress
Configuration:
- Hostname: kubecost.andherson33.click
- Class: nginx-external
- SSL Redirect: Disabled
- Backend Protocol: HTTP
- Proxy Body Size: 0 (unlimited)
- Path: /
- Service: kubecost-cost-analyzer
- Port: 9090

### Tolerations and Node Selectors
Configuration:
- Tolerations:
  - Key: workload-type
  - Value: infrastructure
  - Effect: PreferNoSchedule
- NodeSelector:
  - node-type: infrastructure
  - workload-type: platform

<a name="deployment"></a>
## Deployment
Deploy with ArgoCD with Helm
```bash
kubectl apply -f argocd-kubecost.yaml
```

<a name="access"></a>
## Access
Kubecost will be available at:
URL: https://kubecost.andherson33.click
Alternatively, you can use port-forwarding for local access:
```bash
kubectl port-forward svc/kubecost-cost-analyzer 9090:9090 -n kubecost
```
Local URL: http://localhost:9090

<a name="verification"></a>
## Verification
### Verify Kubecost pods
```bash
kubectl get pods -n kubecost
```
### Verify the ingress
```bash
kubectl get ingress -n kubecost
```
### Verify the services
```bash
kubectl get svc -n kubecost
```
### Verify the deployments
```bash
kubectl get deployments -n kubecost
```
### Verify Prometheus integration
```bash
kubectl exec -it deployment/kubecost-cost-analyzer -n kubecost -- curl -s http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090/-/healthy
```

### Kubecost Dashboard
- Verification of functionality via ingress
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/kubecost-helm/imagenes/kube-cost-1.png)
- Verification of functionality
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/kubecost-helm/imagenes/kube-cost-2.png)
