> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Jaeger with Persistence in Kubernetes](#item1)
* [Description](#item2)
* [Requirements](#item3)
* [Installation](#item4)
* [Verification](#item5)
* [Components](#item6)

<a name="item1"></a>
# Jaeger with Persistence in Kubernetes
This repository contains the necessary configuration to deploy Jaeger with persistent storage in Kubernetes, integrated with Istio for telemetry collection.

<a name="item2"></a>
## Description
This implementation includes:
- Jaeger All-in-One with persistent Badger storage
- Integration with Istio for telemetry collection
- Services for Zipkin, collection, and querying
- Persistence using NFS

## About Jaeger
Jaeger is an open-source distributed tracing tool used to monitor and troubleshoot distributed systems and microservices. This implementation is integrated with Istio v[version] to provide complete observability capabilities.

<a name="item3"></a>
## Requirements
- Kubernetes cluster
- Istio installed and configured
- NFS server configured and accessible (172.16.0.142)
- NFS directory created (/data/jagger)

<a name="item4"></a>
## Installation
1. Apply the storage configuration
```
kubectl apply -f jagger-deploy-svc.yaml
```
2. Apply the Jaeger manifests
```
kubectl apply -f jagger-pv-pvc.yaml
```
3. Apply the Istio telemetry configuration
```
kubectl apply -f telemetry.yaml
```

<a name="item5"></a>
## Verification
Pod and svc
![jagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-1.png)
Dashboard
![jagger-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-2.png)
![jagger-3](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-3.png)

<a name="item6"></a>
## Components
### Persistent Storage
#### PersistentVolume
- Type: NFS
- Capacity: 10Gi
- Reclaim Policy: Retain
- NFS Server: 172.16.0.142
- NFS Path: /data/jagger
- Access Mode: ReadWriteOnce

#### PersistentVolumeClaim
- Namespace: istio-system
- Requested Capacity: 10Gi
- StorageClass: nfs
- Access Mode: ReadWriteOnce

### Deployment
- Uses the `jaegertracing/all-in-one:1.58` image
- Configured with Badger storage
- Data retention set to 24 hours
- Maintenance scheduled every 15 minutes

### Services
1. `tracing` (Port 80, 16685)
   - User interface and queries
   - gRPC support
2. `zipkin` (Port 9411)
   - Compatibility with Zipkin format
3. `jaeger-collector` (Multiple ports)
   - HTTP: 14268
   - gRPC: 14250
   - Zipkin: 9411
   - OpenTelemetry: 4317, 4318

## Istio Telemetry Configuration
1. `Data Collection`
   - Istio automatically captures metrics, traces, and logs of all traffic passing through the mesh
   - Envoy sidecars act as data collection points
