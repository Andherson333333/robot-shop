> Spanish version of this README is available as ReadmeES.md

# Prometheus Stack

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Accessing Interfaces](#access)
* [Monitoring Istio](#monitoring-istio)
* [Customization](#customization)
* [Resource Considerations](#resources)
* [Troubleshooting](#troubleshooting)
* [Maintenance](#maintenance)
* [Verification](#verification)

<a name="description"></a>
## General Description
This repository contains the configuration of the Kube Prometheus Stack for monitoring Kubernetes clusters. The stack includes Prometheus, Grafana, AlertManager, and other components necessary for a complete monitoring solution.

<a name="prerequisites"></a>
## Prerequisites
- Running Kubernetes cluster (EKS)
- Helm 3.x installed
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
├── Chart.yaml
├── templates/
│   └── ingress.yaml                         # Ingress configuration for Prometheus and Grafana
│   └── prometheus-operator-istior.yaml      # Istio configuration for Prometheus
├── values.yaml                              # Custom stack configuration
└── README.md                                # This documentation
```

<a name="configuration"></a>
## Configuration

### Chart.yaml
This file defines the chart dependencies, mainly the kube-prometheus-stack.

### values.yaml
The values file contains the specific configuration for each component of the stack. Highlights:

- **Node Configuration**: All components run on infrastructure nodes with label `node-type: infrastructure` except for the node-exporter which must run on all nodes.
- **Storage**: All components that require persistence use the storage class `gp3-default`.
- **Retention**: Prometheus retains metrics for 15 days.
- **Access**: Configured through internal Ingress to access Prometheus and Grafana exclusively from within the VPC.

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-1.png)


<a name="installation"></a>
## Installation

To install the Prometheus stack, run:

```bash
# Create the namespace
kubectl create namespace monitoring

# Update Helm dependencies
helm dependency update

# Install the chart
helm install prometheus-stack . -n monitoring
```

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

This chart includes configurations to monitor Istio components:

1. **PodMonitor for Envoy**: Collects metrics from Istio proxies (sidecars)
2. **ServiceMonitor for Istio components**: Monitors the components of the Istio control plane

<a name="customization"></a>
## Customization

To customize the configuration:

1. Modify the `values.yaml` file according to your needs
2. Update the chart with:
   ```bash
   helm upgrade prometheus-stack . -n monitoring
   ```

<a name="resources"></a>
## Resource Considerations

The components have the following storage requirements:

- **Prometheus**: 10Gi
- **Grafana**: 10Gi
- **AlertManager**: 10Gi

Make sure your cluster has enough available resources.

<a name="troubleshooting"></a>
## Troubleshooting

If you encounter issues with the deployment:

1. Verify that all pods are in Running state:
   ```bash
   kubectl get pods -n monitoring
   ```

2. Check the logs of problematic pods:
   ```bash
   kubectl logs -n monitoring <pod-name>
   ```

3. Check that the Ingresses are correctly configured:
   ```bash
   kubectl get ingress -n monitoring
   ```

4. For access problems:
   ```bash
   # Verify that you are using the internal ingress-controller
   kubectl get ingress -n monitoring -o wide
   
   # Verify that you are accessing from within the VPC
   # You can use a temporary pod to test:
   kubectl run curl-test --image=curlimages/curl -i --tty -- sh
   curl -k https://dev1-prometheus.andherson33.click
   ```

<a name="maintenance"></a>
## Maintenance

To update the stack to a new version:

1. Update the `kube-prometheus-stack` version in the `Chart.yaml` file
2. Run:
   ```bash
   helm dependency update
   helm upgrade prometheus-stack . -n monitoring
   ```

<a name="verification"></a>
## Verification

To verify that the deployment has been completed successfully:

```bash
# Verify pods
kubectl get pods -n monitoring
```

```bash
# Verify services
kubectl get svc -n monitoring
```

```bash
# Verify ingress
kubectl get ingress -n monitoring
```

```bash
# Verify PVCs
kubectl get pvc -n monitoring
```

```bash
# Verify monitors
kubectl get servicemonitor -n istio-system
```

```bash
# Verify pod monitors
kubectl get podmonitor -n istio-system
```

- Pods, services, and pvc
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-2.png)

- Prometheus targets
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-3.png)

- Dashboard list

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-5.png)

- Operation verification
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-4.png)
