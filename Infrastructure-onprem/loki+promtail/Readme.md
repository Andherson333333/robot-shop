> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Logging Configuration with Loki and Promtail for Istio](#item1)
* [Requirements](#item2)
* [Architecture](#item3)
* [Loki Installation](#item4)
* [Loki Verification](#item5)
* [Promtail Configuration and Installation](#item6)
* [Promtail Installation with Helm](#item7)
* [Promtail Verification](#item8)
* [Grafana Configuration](#item9)
* [Final Functionality](#item10)


<a name="item1"></a>
# Logging Configuration with Loki and Promtail for Istio

This repository contains the configuration to implement a complete logging stack using Loki as the storage backend and Promtail as the log collection agent, optimized to work with Istio service mesh.

<a name="item2"></a>
## Requirements

- Kubernetes Cluster
- Istio service mesh installed
- NFS server configured and accessible
- Helm 3.x (for Promtail)
- StorageClass for NFS configured
  
<a name="item3"></a>
## Architecture

- `Loki:` Log aggregation system installed in the `istio-system` namespace (installed via manifests)
- `Promtail:` Log collection agent in a dedicated namespace (installed via Helm)
- `Storage:` NFS for data persistence (10GB)
- `Service Mesh:` Integration with Istio

<a name="item4"></a>
## Loki Installation

1. NFS Storage Configuration, create the PersistentVolume for Loki
```
kubectl apply -f pv-loki.yaml
```
2. Deploy loki.yaml manifest that was modified to create the pv (original source https://github.com/istio/istio/blob/master/samples/addons/loki.yaml)
```
kubectl apply -f loki.yaml
```
<a name="item5"></a>
## Loki Verification

pv

![loki-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-3.png)

pod and svc
![loki-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-2.png)


<a name="item6"></a>
# Promtail Configuration and Installation

## Log Collection and Labeling

The configuration includes specialized relabeling rules that:

### 1. Capture Kubernetes Metadata
- Pod namespace
- Pod name
- Container name

### 2. Log Classification
- `envoy`: Logs from Istio proxy containers
- `application`: Logs from application containers

## Connection with Loki

- Endpoint: `http://loki.istio-system.svc.cluster.local:3100/loki/api/v1/push`
- Service discovery via internal cluster DNS

## Monitoring

- ServiceMonitor enabled for Prometheus
- Promtail performance metrics

<a name="item7"></a>
## Promtail Installation with Helm

To install Promtail using this configuration:
1. Create a `values.yaml` file with the provided configuration
2. Create the namespace for Promtail:
```
kubectl create namespace promtail
```
3. Install the Promtail repository
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```
4. Install Promtail with Helm
```
helm install promtail grafana/promtail -f values.yaml -n istio-system
```

<a name="item8"></a>
## Promtail Verification

 Helm
![promtail-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-promtail-2.png)

pod and svc
![promtail-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-promtail-1.png)

<a name="item9"></a>
# Grafana Configuration

After configuring, verify that it's working. This can be done in various ways but will be done through Grafana

1. Add Loki to the data sources
2. Then perform some test queries
3. Create queries for the dashboard
```
{namespace="robot-shop", pod=~"web.*"}
{namespace="robot-shop", pod=~"cart.*"}
{namespace="robot-shop", pod=~"catalogue.*"}
{namespace="robot-shop", pod=~"user.*"}
{namespace="robot-shop", pod=~"payment.*"}
{namespace="robot-shop", pod=~"shipping.*"}
{namespace="robot-shop", pod=~"ratings.*"}
{namespace="robot-shop", pod=~"dispatch.*"}
{namespace="robot-shop", pod=~"mysql.*"}
{namespace="robot-shop", pod=~"mongodb.*"}
{namespace="robot-shop", pod=~"redis.*"}
{namespace="robot-shop", pod=~"rabbitmq.*"}
```
4. Create Grafana dashboard for the application
![grafana-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-1.png)

<a name="item10"></a>
## Final Functionality
- Automatic collection of logs from pods with Istio
- Log classification (envoy/application)
- Data persistence in NFS
- Monitoring via ServiceMonitor
- Internal DNS for service discovery
- High availability with StatefulSet
