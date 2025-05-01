> Spanish version of this README is available as ReadmeES.md

## Flagger Canary Deployment Demo
This repository contains the necessary configuration to implement canary deployments using Flagger in Kubernetes with Istio as the service mesh provider.

## Table of Contents
* [Flagger](#item1)
* [Canary](#item2)
* [Requirements](#item3)
* [Installation](#item4)
* [Traffic Simulation](#item5)
* [Verification](#item6)

<a name="item1"></a>
## Flagger
Flagger is a progressive delivery tool for Kubernetes that automates the canary deployment process. In this implementation, it is configured to work with Istio as the service mesh provider and uses Prometheus for metrics collection.
Main features of our configuration:

- Metrics monitoring through Prometheus
- Integration with Istio
- Automated resource management
- Enabled metrics system

<a name="item2"></a>
## Canary Deployments
Canary deployments are a release strategy that allows testing new software versions with a limited portion of real users before a full deployment. Similar to the canaries that miners used to detect toxic gases, this technique acts as an early warning system for potential problems.

The new version initially receives a small percentage of traffic (10%), which gradually increases while key metrics such as errors and latency are monitored. If everything works correctly, traffic is increased; if there are problems, it automatically reverts.
In our implementation:

- Analysis every 30 seconds
- Maximum 50% of traffic for the canary version
- 10% increments
- Monitoring of success and performance metrics

This strategy allows us to deploy new versions safely and in a controlled manner, minimizing risks for our users.

- Request success rate (minimum 99%)
- Request duration (maximum 500ms)

<a name="item3"></a>
## Requirements

- Kubernetes cluster
- Istio installed and configured
- Prometheus operational in the monitoring namespace
- Helm (for Flagger installation)

<a name="item4"></a>
## Installation

1. Create namespace flagger flagger-system
```
kubectl create namespace flagger-system
```
2. Add Helm repositories and update
```
helm repo add flagger https://flagger.app
helm repo update
```
3. Install the Helm chart with the values.yaml file
```
helm upgrade -i flagger flagger/flagger \
  --namespace=flagger-system \
  --values=values.yaml
```
4. Verify installation
```
kubectl get pods -n flagger-system
kubectl get deploy -n flagger-system
kubectl logs deployment/flagger -n flagger-system
```

<a name="item5"></a>
## Traffic Simulation

The repository includes a load test Job (loadtesthttp.yaml) that simulates traffic to the application:

- Performs external web access tests
- Executes requests to specific products
- Maintains a constant flow of traffic for analysis

```
kubectl apply -f loadtHTTP.yaml
```

<a name="item6"></a>
## Verification

Let's apply the catalog configuration to test the functionality, simulating traffic through a job
```
kubectl apply -f catalogue.yaml
```
Once applied, we verify the canary
```
kubectl get canaries -n robot-shop
```
Subsequently, the image will be updated to start the process
```
kubectl set image deployment/catalogue catalogue=andherson1039/rs-catalogue:v1 -n robot-shop
```

Now the verification will be performed with the Kiali tool to visualize the canary process

1. Service Topology
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-1.png)
2. Deployment by Versions
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-2.png)
3. Load Distribution
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-3.png)
4. Active Canary Deployment
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-4.png)
5. Complete Architecture
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-5.png)
6. Canary Deployment in Action
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-6.png)
7. Traffic Distribution Between Versions
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-7.png)
8. Canary Deployment Progress - Final State
![flagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-flagger-8.png)
