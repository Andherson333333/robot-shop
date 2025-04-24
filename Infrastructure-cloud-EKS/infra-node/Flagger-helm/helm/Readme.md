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
├── Chart.yaml         # Helm chart metadata, includes name, version, and dependencies
├── values.yaml        # Configurable values to customize the installation
└── templates/         # Templates for the Kubernetes resources that will be created
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
