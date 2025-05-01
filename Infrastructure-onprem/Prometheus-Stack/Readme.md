> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Monitoring with Prometheus & Istio](#item1)
* [Features](#item2)
* [Requirements](#item3)
* [Installation](#item4)
* [Verification](#item5)
* [References](#item6)

<a name="item1"></a>
# Monitoring with Prometheus & Istio
This repository contains the necessary configuration to implement Prometheus together with Istio, providing a robust monitoring solution for Kubernetes clusters.

<a name="item2"></a>
## Features
- Automated monitoring of Istio services
- Persistent storage on NFS
- Preconfigured dashboards in Grafana
- Collection of Envoy Proxy metrics

<a name="item3"></a>
## Requirements
- Helm
- NFS
- Kubernetes Cluster
- Istio 

<a name="item4"></a>
## Installation
1. Create Namespace
```
kubectl create ns monitoring
```
2. Configure Storage
```
kubectl apply -f pv-prometheus.yaml
```
3. Install Prometheus with helm
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
4. Apply the values, configured for integration with Istio and to create a PV to store data in an NFS or path
```
helm install prometheus prometheus-community/kube-prometheus-stack -f values.yaml -n monitoring
```
5. Configure Integration with Istio
```
kubectl apply -f prometheus-operator.yaml
```
6. Access to Interfaces
```
kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

<a name="item5"></a>
## Verification
- Prometheus pod 
![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-prometues-1.png)
- Prometheus with Istio Dashboard
![dashboard](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-prometues-3.png)
- Grafana 
![grafana-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-graphana-2.png)
![grafana-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-graphana-1.png)

<a name="item6"></a>
## References
- [Official Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Istio Documentation](https://istio.io/latest/docs/ops/integrations/prometheus/)
- [Prometheus Helm Charts](https://github.com/prometheus-community/helm-charts)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
