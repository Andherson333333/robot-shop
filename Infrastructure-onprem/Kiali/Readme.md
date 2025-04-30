> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Kiali Configuration with Istio](#item1)
* [Requirements](#item2)
* [Installation](#item3)
* [Verification](#item4)

<a name="item1"></a>
# Kiali Configuration with Istio
## General Description
This documentation covers the configuration of Kiali with Istio, including integration with Grafana and Prometheus for monitoring and observability.

<a name="item2"></a>
## Requirements
- Kubernetes Cluster
- Istio (Already installed)

<a name="item3"></a>
## Installation
1. Deploy the kiali.yaml manifest (original source)
```
kubectl apply -f kiali.yaml
```
2. After deployment, there will be an error since Prometheus Operator is installed, so add the endpoint to the Kiali configmap
```
kubectl edit configmap kiali -n istio-system
```
This is what goes inside the configmap in the external_service section
```
 external_services:
      custom_dashboards:
        enabled: true
      prometheus:
        url: http://prometheus-kube-prometheus-prometheus.monitoring:9090
      grafana:
        external_url: http://prometheus-grafana.monitoring:80
        in_cluster_url: http://prometheus-grafana.monitoring:80
      istio:
        root_namespace: istio-system
      tracing:
        enabled: false
```
![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-kiali-2.png)

<a name="item4"></a>
## Verification
Once configured and the application starts receiving packets, it begins to display them
![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-kiali-1.png)
