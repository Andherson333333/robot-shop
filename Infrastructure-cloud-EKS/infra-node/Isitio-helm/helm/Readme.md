> Spanish version of this README is available as ReadmeES.md

# Istio Service Mesh
## Table of Contents
* [General Description](#description)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Verification](#verification)

<a name="description"></a>
## General Description
This repository contains the configuration to deploy Istio Service Mesh in a Kubernetes cluster. Istio is a service mesh platform that provides traffic management, security, observability, and policy capabilities for modern microservices-based applications.

<a name="structure"></a>
## Repository Structure
```
.
├── Chart.yaml          # Istio dependencies definition
├── templates/          # Additional custom resources
├── values.yaml         # Custom Istio configuration
└── README.md           # This documentation
```

### Chart.yaml
This file defines the dependencies for the Istio chart:
```yaml
apiVersion: v2
name: istio
description: Istio Installation Bundle
version: 1.0.0
dependencies:
  - name: base
    version: 1.24.2
    repository: https://istio-release.storage.googleapis.com/charts
  - name: istiod
    version: 1.24.2
    repository: https://istio-release.storage.googleapis.com/charts
```
- **Base (v1.24.2)**: Fundamental components and CRDs installation
- **Istiod (v1.24.2)**: Istio control plane

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-1.png)

<a name="configuration"></a>
## Configuration
### values.yaml
The values file contains the specific configuration for Istio components:
```yaml
global:
  nodeSelector:
    node-type: infrastructure
    workload-type: platform
  # Toleration configuration for all components 
  tolerations:
  - key: "workload-type"
    value: "infrastructure"
    effect: "NoSchedule"
base:
  enabled: true
istiod:
  meshConfig:
    enableTracing: true
    extensionProviders:
      - name: jaeger
        opentelemetry:
          port: 4317
          service: jaeger-collector.istio-system.svc.cluster.local
```

**Key features:**
- Enables Istio base components
- Activates tracing through Jaeger using OpenTelemetry
- Deploys on infrastructure nodes (`node-type: infrastructure`)

<a name="installation"></a>
## Installation
To install Istio, run:
```bash
# Create the Istio namespace
kubectl create namespace istio-system
# Update Helm dependencies
helm dependency update
# Install the chart
helm install istio . -n istio-system
```

<a name="verification"></a>
## Verification
To verify that Istio has been installed correctly:
```bash
# Verify that Istio pods are running
kubectl get pods -n istio-system
# Check the Istio version
kubectl get pods -l app=istiod -n istio-system -o jsonpath='{.items[0].metadata.labels.istio\.io/rev}'
# Verify that pods are running on infrastructure nodes
kubectl get pods -n istio-system -o wide
```

- Istio pod and service
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-3.png)
- Applying Istio to the application
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/robot-shop-eks-2.png)
