> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Istio](#item1)
* [Requirements](#item2)
* [Installation](#item3)
* [Verification](#item4)
* [Troubleshooting](#item5)

<a name="item1"></a>
# Istio 
This repository contains the necessary configuration to implement Istio with Helm, configuring the values to collect telemetry to work with Jaeger, with the rest remaining as default.

<a name="item2"></a>
## Requirements
- Helm
- Kubernetes Cluster

<a name="item3"></a>
## Installation
1. First, add the Istio Helm repository
```
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```
2. Create the namespace for Istio:
```
kubectl create namespace istio-system
```
3. Create a values.yaml file
```
touch values.yaml
```
4. Install Istio base
```
helm install istio-base istio/base \
  --namespace istio-system \
  --version 1.24.1
```
5. Install Istiod (control plane)
```
helm install istiod istio/istiod \
  --namespace istio-system \
  --values values.yaml \
  --version 1.24.1
```
6. Configuration explained
- `enableTracing:` true: Activates traceability capability in the mesh
- `extensionProviders:` Configures Jaeger as the traceability provider
- `Port 4317:` Standard port for OpenTelemetry
- The service points to the Jaeger collector in the istio-system namespace

<a name="item4"></a>
## Verification
Once installed, we verify pod and service; if there's any error, check logs and pods
![istio-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-istio-2.png)

<a name="item5"></a>
## Troubleshooting
Useful commands for diagnosis:
```
kubectl describe pod <pod-name> -n istio-system
```
```
kubectl logs -f <pod-name> -n istio-system
```
