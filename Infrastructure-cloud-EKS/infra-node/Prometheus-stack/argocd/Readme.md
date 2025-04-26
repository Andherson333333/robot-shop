> Spanish version of this README is available as ReadmeES.md

# Prometheus Stack with ArgoCD

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Accessing Interfaces](#access)
* [Monitoring Istio](#monitoring-istio)
* [Limitations and Considerations](#limitations)
* [Verification](#verification)

<a name="description"></a>
## General Description
This repository contains the configuration to deploy the Kube Prometheus Stack in a Kubernetes cluster using ArgoCD. The stack includes Prometheus, Grafana, AlertManager, and other components necessary for a complete monitoring solution.

<a name="prerequisites"></a>
## Prerequisites
- Running Kubernetes cluster (EKS)
- ArgoCD installed and configured
- Ingress Controller (nginx-internal)
- StorageClass `gp3-default` configured

<a name="components"></a>
## Components
- **Prometheus**: Monitoring system and time series database
- **Grafana**: Visualization and analysis platform for metrics
- **AlertManager**: Alert manager for Prometheus
- **kube-state-metrics**: Exporter that generates metrics about the state of Kubernetes objects
- **node-exporter**: Collects node-level metrics (hardware and OS)
- **Prometheus Operator**: Facilitates the management of Prometheus in Kubernetes

<a name="structure"></a>
## Repository Structure
```
.
└── argocd-prometheus.yml  # ArgoCD application definition for Prometheus Stack
```

<a name="configuration"></a>
## Configuration

The configuration points to the repository where the Prometheus Stack chart is located and establishes automatic synchronization policies.

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-1.png)

<a name="installation"></a>
## Installation

To deploy the Prometheus stack with ArgoCD:

```bash
# Apply the application definition
kubectl apply -f argocd-prometheus.yml

# Verify that the application has been created
kubectl get applications -n argocd
```

You can also create the application from the ArgoCD web interface:

1. Access the ArgoCD UI
2. Select "New App"
3. Fill in the fields according to the configuration in argocd-prometheus.yml
4. Click "Create"

<a name="access"></a>
## Accessing Interfaces

Once deployed, you can access the interfaces through the following URLs **only from within the VPC**:

- **Prometheus**: https://dev1-prometheus.andherson33.click
- **Grafana**: https://dev1-grafana.andherson33.click
  - Default username: admin
  - Default password: admin

### Important: Internal Access Only
All services are configured with the ingressClassName `nginx-internal`, which means:
- They are only accessible from within the VPC
- They are not exposed to the Internet
- To access from outside the VPC, a VPN connection or AWS Direct Connect is required

<a name="monitoring-istio"></a>
## Monitoring Istio

The configuration includes resources to monitor Istio components:

1. **PodMonitor for Envoy**: Collects metrics from Istio proxies (sidecars)
2. **ServiceMonitor for Istio components**: Monitors the components of the Istio control plane

<a name="limitations"></a>
## Limitations and Considerations

### 1. Issues with Saturated Nodes and Karpenter
When using ArgoCD to deploy Prometheus Stack in clusters that use Karpenter as an auto-scaler, issues may arise with the node-exporter on nodes that are saturated:

- **Problem**: The node-exporter may fail to deploy on nodes that are at their capacity limit
- **Impact**: Loss of system-level metrics for those nodes

### 2. Size Limitation in ArgoCD
ArgoCD has a limitation with large resources:

- **Problem**: The Prometheus Stack chart generates very large manifests (>256KB) that may exceed ArgoCD limits
- **Symptom**: The application does not synchronize correctly or shows synchronization errors

<a name="verification"></a>
## Verification

To verify that the deployment has been completed successfully:

```bash
# Verify the application status in ArgoCD
kubectl get application prometheus-stack -n argocd

# Verify pods
kubectl get pods -n monitoring

# Verify services
kubectl get svc -n monitoring

# Verify ingress
kubectl get ingress -n monitoring
```

- Synchronization status in ArgoCD
![ArgoCD Sync](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-argocd.png)

- Pods, services, and pvc
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-2.png)

- Prometheus targets
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-3.png)

- Operation verification
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-4.png)
