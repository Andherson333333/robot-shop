> Spanish version of this README is available as ReadmeES.md

# Flagger Helm Chart Configuration
## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [File Structure](#file-structure)
* [Configuration](#configuration)
* [Deployment](#deployment)
* [Verification](#verification)
* [Access](#access)
  
<a name="description"></a>
## General Description
This module implements Flagger in the Kubernetes cluster, providing a progressive delivery tool that automates the release process for applications. Flagger reduces the risk of introducing new versions in production by gradually shifting traffic to the new version while monitoring metrics and performing conformance tests.

<a name="prerequisites"></a>
## Prerequisites
- Kubernetes cluster >=1.16.0
- Istio, Linkerd, App Mesh, NGINX, or Contour installed
- For Istio, v1.0.0 or newer with Prometheus is required
- Prometheus configured at the specified URL
- ArgoCD deployed
- Helm >= 3.0
- kubectl

<a name="components"></a>
## Components
The deployment configures:
- Flagger in a dedicated namespace
- Progressive deployment controller
- Pod monitoring through PodMonitor
- Integration with Istio for traffic control

<a name="file-structure"></a>
## File Structure
```
.
├── argocd-flagger.yaml         # Deployment for argocd
```

<a name="configuration"></a>
## Configuration
### Flagger Helm Chart
Configuration:
- Name: flagger
- Repository: https://flagger.app
- Version: 1.40.0
- Type: application

### Service Mesh Provider
Configuration:
- Provider: istio
- Metrics server: http://prometheus-stack-kube-prom-prometheus.monitoring:9090
- Metrics interval: 15s
- Telemetry interval: 5s

### Resources
Configuration:
- Requests:
  - CPU: 100m
  - Memory: 128Mi
- Limits:
  - CPU: 1000m
  - Memory: 512Mi

### Monitoring
Configuration:
- PodMonitor: Enabled
- Metrics: Enabled
- Log level: info

### Scheduling
Configuration:
- Tolerations: Infrastructure (PreferNoSchedule)
- NodeSelector:
  - node-type: infrastructure
  - workload-type: platform
- Affinity: Not configured

### RBAC and Service Account
Configuration:
- RBAC: Enabled
- PSP: Disabled
- Service account: Created with name "flagger"

<a name="deployment"></a>
## Deployment
This time it will be deployed with ArgoCD
To deploy Flagger:
```bash
kubectl apply -f argocd-flagger.yaml
```

<a name="verification"></a>
## Verification
### Verify Flagger pods
```bash
kubectl get pods -n flagger
```
### Verify services
```bash
kubectl get svc -n flagger
```
### Verify Flagger configuration
```bash
kubectl get canaries --all-namespaces
```
### Verify created resources
```bash
kubectl get deployment,sa,clusterrole,clusterrolebinding -l app.kubernetes.io/name=flagger
```
 ```bash
kubectl get canaries --all-namespaces
kubectl describe canary [canary-name] -n [namespace]
 ```
- Verification of operation with robot-shop catalogue
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Flagger-helm/imagenes/flagger-1.png)
- Verification of deployment with argocd
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Flagger-helm/imagenes/flagger-2.png)
