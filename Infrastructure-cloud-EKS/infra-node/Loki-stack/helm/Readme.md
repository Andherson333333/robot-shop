> Spanish version of this README is available as ReadmeES.md

# Loki-Promtail Stack for Kubernetes

## Table of Contents
* [General Description](#description)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Accessing Logs](#access)
* [Grafana Configuration](#grafana)
* [Verification](#verification)

<a name="description"></a>
## General Description
This Helm chart deploys Loki (log storage and query system) and Promtail (agent for sending logs) in a Kubernetes cluster. It provides a lightweight and efficient centralized logging solution, perfect for Kubernetes environments.

<a name="structure"></a>
## Repository Structure
```
.
├── Chart.yaml          # Chart definition and dependencies
├── values1.yaml        # Standard configuration
├── values2.yaml        # Alternative configuration with affinity
└── README.md           # This documentation
```

<a name="configuration"></a>
## Configuration
This chart is based on `loki-stack` and provides two different configurations:

### Standard Configuration (values1.yaml)
- Loki is deployed on infrastructure nodes
- Promtail is deployed on all nodes as a DaemonSet
- 10Gi persistent storage for Loki
- Log labeling by namespace, pod, container, and type (envoy/application)

### Alternative Configuration (values2.yaml)
- Loki is deployed on infrastructure nodes
- Promtail is deployed only on application nodes (excludes infrastructure nodes)
- Same labeling capabilities as the standard configuration

<a name="installation"></a>
## Installation

```bash
# Create the namespace
kubectl create namespace logging

# Update dependencies
helm dependency update

# Install with standard configuration
helm install loki-stack . -n logging -f values1.yaml

# Alternatively, install with alternative configuration
helm install loki-stack . -n logging -f values2.yaml
```

<a name="access"></a>
## Accessing Logs

Logs can be queried through:

- **Grafana**: By configuring a Loki datasource at `http://loki-stack:3100`
- **Loki API**: Accessible at `http://loki-stack:3100/loki/api/v1/query`

<a name="grafana"></a>
## Grafana Configuration

To configure Loki as a data source in Grafana:

1. Access the Grafana web interface
