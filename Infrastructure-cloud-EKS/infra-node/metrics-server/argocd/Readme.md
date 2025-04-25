> Spanish version of this README is available as ReadmeES.md

# Metrics Server

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Verification](#verification)
* [Common Use](#use)
* [Troubleshooting](#troubleshooting)

<a name="description"></a>
## General Description
This repository contains the Metrics Server configuration for Kubernetes, an essential component that collects resource metrics such as CPU and memory from nodes and pods in the cluster. These metrics are used by cluster components such as the Horizontal Pod Autoscaler and the Vertical Pod Autoscaler.

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/metrics-server/imagenes/metric-1.png)


<a name="prerequisites"></a>
## Prerequisites
- Running Kubernetes cluster (EKS)
- Helm 3.x installed
- Nodes with label `node-type: infrastructure` to host the Metrics Server

<a name="components"></a>
## Components
- **Metrics Server**: Cluster resource metrics aggregator that collects data from Kubelets

<a name="structure"></a>
## Repository Structure
```
.
├── Chart.yaml         # Chart definition and dependencies
├── values.yaml        # Custom configuration for Metrics Server
└── README.md          # This documentation
```

<a name="configuration"></a>
## Configuration

### Chart.yaml
This file defines the chart dependencies, mainly the Metrics Server.

### values.yaml
The values file contains the specific configuration for the Metrics Server:

#### Key configuration:
- **ApiService**: Enabled to automatically register the API service
- **Metrics resolution**: Configured to collect metrics every 15 seconds
- **TLS security**: Configured to accept insecure connections with kubelets (--kubelet-insecure-tls)
- **NodeSelector**: Ensures that the Metrics Server runs on infrastructure nodes
- **Tolerations**: Allows the pod to run on nodes with specific taints

<a name="installation"></a>
## Installation

To install the Metrics Server, run:

```bash
# Install using ArgoCD
kubectl apply -f argocd-metric.yml
```

<a name="verification"></a>
## Verification

To verify that the Metrics Server has been installed correctly:

```bash
# Verify that the pod is running
kubectl get pods -n kube-system | grep metrics-server

# Verify that the API service is registered
kubectl get apiservices | grep metrics.k8s.io

# Check that metrics are being collected
kubectl top nodes
kubectl top pods -A
```

- Installation with ArgoCD UI
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/metrics-server/imagenes/metric-2.png)

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/metrics-server/imagenes/metric-3.png)


<a name="use"></a>
## Common Use

The Metrics Server is primarily used for:

1. **Horizontal Pod Autoscaling (HPA)**:
   ```bash
   kubectl autoscale deployment my-application --cpu-percent=80 --min=1 --max=10
   ```

2. **Node resource monitoring**:
   ```bash
   kubectl top nodes
   ```

3. **Pod resource monitoring**:
   ```bash
   kubectl top pods -A
   ```

<a name="troubleshooting"></a>
## Troubleshooting

If you encounter issues with the Metrics Server:

1. **Check pod status**:
   ```bash
   kubectl describe pod -n kube-system -l k8s-app=metrics-server
   ```

2. **Review logs**:
   ```bash
   kubectl logs -n kube-system -l k8s-app=metrics-server
   ```

3. **Check connectivity with kubelets**:
   If logs show connectivity issues with kubelets, verify:
   - That security rules allow traffic between the Metrics Server and kubelets
   - That TLS certificates are configured correctly (or that --kubelet-insecure-tls is enabled)

4. **Issues with `kubectl top`**:
   If the `kubectl top` command doesn't work, verify that the API Service is registered:
   ```bash
   kubectl get apiservices v1beta1.metrics.k8s.io -o yaml
   ```
   
   The `status.conditions` field should show `Available: True`
