> Spanish version of this README is available as ReadmeES.md

## Table of Contents
* [Robot Shop Kubernetes Manifests](#item1)
* [Project Structure](#item2)
* [Requirements](#item3)
* [Deployment](#item4)
* [Verification](#item5)
* [Kubernetes Technologies Used](#item6)

<a name="item1"></a>
# Robot Shop Kubernetes Manifests

This repository contains the Kubernetes manifests needed to deploy the Robot Shop application, a demonstration robot store that uses a microservices architecture.

<a name="item2"></a>
## Project Structure

The project is organized in a main directory that contains all the Kubernetes manifests needed for the deployment of the Robot Shop application:

<pre>
manifiestos/
|-- cart-deployment.yaml
|-- cart-hpa.yaml
|-- cart-service.yaml
|-- catalogue-deployment.yaml
|-- catalogue-hpa.yaml
|-- catalogue-service.yaml
|-- dispatch-deployment.yaml
|-- dispatch-hpa.yaml
|-- dispatch-service.yaml
|-- mongodb-pv.yaml
|-- mongodb-service.yaml
|-- mongodb-statefulset.yaml
|-- mysql-configmap.yaml
|-- mysql-pv.yaml
|-- mysql-secret.yaml
|-- mysql-service.yaml
|-- mysql-statefulset.yaml
|-- namespace.yaml
|-- payment-deployment.yaml
|-- payment-hpa.yaml
|-- payment-service.yaml
|-- rabbitmq-deployment.yaml
|-- rabbitmq-service.yaml
|-- ratings-configmap.yaml
|-- ratings-deployment.yaml
|-- ratings-hpa.yaml
|-- ratings-secret.yaml
|-- ratings-service.yaml
|-- redis-deployment.yaml
|-- redis-service.yaml
|-- shipping-configmap.yaml
|-- shipping-deployment.yaml
|-- shipping-hpa.yaml
|-- shipping-secret.yaml
|-- shipping-service.yaml
|-- user-deployment.yaml
|-- user-hpa.yaml
|-- user-service.yaml
|-- web-configmap.yaml
|-- web-deployment.yaml
|-- web-hpa.yaml
|-- web-service.yaml
</pre>

![structure](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

<a name="item3"></a>
## Requirements

- Working Kubernetes cluster (v1.19+)
- kubectl installed and configured
- Support for PersistentVolumes (databases)

<a name="item4"></a>
## Deployment

1. Create the namespace
```
kubectl apply -f manifiestos/namespace.yaml
```
2. Deploy the database services (MongoDB and MySQL)
```
kubectl apply -f manifiestos/mongodb-pv.yaml
kubectl apply -f manifiestos/mongodb-service.yaml
kubectl apply -f manifiestos/mongodb-statefulset.yaml
kubectl apply -f manifiestos/mysql-configmap.yaml
kubectl apply -f manifiestos/mysql-pv.yaml
kubectl apply -f manifiestos/mysql-secret.yaml
kubectl apply -f manifiestos/mysql-service.yaml
kubectl apply -f manifiestos/mysql-statefulset.yaml
```
3. Deploy the infrastructure services (Redis and RabbitMQ):
```
kubectl apply -f manifiestos/redis-deployment.yaml
kubectl apply -f manifiestos/redis-service.yaml
kubectl apply -f manifiestos/rabbitmq-deployment.yaml
kubectl apply -f manifiestos/rabbitmq-service.yaml
```
4. Deploy the application microservices:
```
kubectl apply -f manifiestos/cart-*.yaml
kubectl apply -f manifiestos/catalogue-*.yaml
kubectl apply -f manifiestos/dispatch-*.yaml
kubectl apply -f manifiestos/payment-*.yaml
kubectl apply -f manifiestos/ratings-*.yaml
kubectl apply -f manifiestos/shipping-*.yaml
kubectl apply -f manifiestos/user-*.yaml
kubectl apply -f manifiestos/web-*.yaml
```
5. Alternatively, you can deploy the entire application with a single command:
```
kubectl apply -f manifiestos/
```

## Verification

- Pod and service
![pod-service](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-6.png)

- deployment and statefulset
![deployment](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-7.png)

- Hpa
![HPA](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-5.png)

- PV 
![pv](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-8.png)

<a name="item6"></a>
## Kubernetes Technologies Used

### Core Resources (v1)
- `Namespace:` Resource isolation and project organization
- `ConfigMap:` Non-sensitive application configurations
- `Secret:` Secure storage of credentials and sensitive data
- `Service:` Service exposure and discovery
  - ClusterIP: Internal communication
  - LoadBalancer: External exposure (Web UI)
  - Headless: Used by StatefulSets (MongoDB, MySQL)
- `PersistentVolume (PV):` Persistent storage for databases
- `PersistentVolumeClaim (PVC):` Storage requests for MongoDB and MySQL

### Workloads (apps/v1)
- `Deployment:` Stateless applications
  - Redis, RabbitMQ
  - Web services (cart, catalogue, payment, etc.)
- `StatefulSet:` Stateful applications
  - MongoDB
  - MySQL

### Autoscaling (autoscaling/v2)
- `HorizontalPodAutoscaler (HPA):` Automatic autoscaling
  - Configured for all services
  - Based on CPU (70%) and Memory (70%)
  - Scales from 1 to 5 replicas

### Resilience Features
- `Init Containers:` Dependency verification
- `Resource Management:`
  - Requests: Guaranteed minimum resources
  - Limits: Maximum resource limits
- `Health Checks:`
  - Liveness Probe: Health verification
  - Readiness Probe: Availability verification

### Configuration and Security
- `Environment Variables:` Environment variables from:
  - ConfigMaps
  - Secrets
  - Direct values
- `Volume Management:` 
  - PersistentVolumes
  - Volume Mounts
  - Volume Claims

### Service Distribution
- `Stateful Services:`
  - MongoDB (StatefulSet + Headless Service)
  - MySQL (StatefulSet + Headless Service)
- `Stateless Services:`
  - Redis (Deployment + ClusterIP)
  - RabbitMQ (Deployment + ClusterIP)
  - Microservices (Deployments + ClusterIP)
  - Web UI (Deployment + LoadBalancer)
