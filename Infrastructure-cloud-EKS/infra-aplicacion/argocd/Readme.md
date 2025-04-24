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

This repository contains the Kubernetes manifests necessary to deploy the Robot Shop application, a demonstration robot store that uses a microservices architecture.

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
|-- mongodb-service.yaml
|-- mongodb-statefulset.yaml
|-- mysql-configmap.yaml
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
|-- web-ingress.yaml
</pre>

![structure](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

![structure](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-aplicacion/K8s/imagenes/robot-shop-5.png)

<a name="item3"></a>
## Requirements

- Kubernetes Cluster
- Kubectl configured to interact with your cluster
- Storage class `gp3-default` available in your cluster
- Nginx Ingress Controller installed
- Configured domain name (currently configured as robotshop.andherson33.click)
- ArgoCD Installed

<a name="item4"></a>
## Deployment

## Verification

Deploy the application using GitOps tools, such as ArgoCD

```
kubectl apply -f argocd-robot-shop.yml
```

- Pod and service
![pod-service](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-aplicacion/K8s/imagenes/robot-shop-eks-2.png)

- Deployment with ArgoCD
![pod-service](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-aplicacion/K8s/imagenes/robot-shop-eks-3.png)

<a name="item6"></a>
## Kubernetes Technologies Used

## Core Resources (v1)
- `Namespace:` robot-shop with istio-injection enabled
- `ConfigMap:` 
 - mysql-config: Database configuration
 - shipping-config: Shipping service configuration
 - ratings-config: Ratings service configuration
 - web-config: Service endpoints configuration
- `Secret:` 
 - mysql-secrets
 - shipping-secrets
 - ratings-secrets
- `Service:` 
 - ClusterIP: Internal services (redis, mysql, mongodb, etc)
 - Headless: For StatefulSets (mongodb-headless, mysql-headless)
- `PersistentVolumeClaim:` 
 - mongodb-pvc
 - mysql-pvc

<a name="workloads"></a>
## Workloads (apps/v1)
- `Deployment:` Stateless services
 - redis
 - rabbitmq
 - catalogue
 - user
 - cart
 - shipping
 - payment
 - dispatch
 - ratings
 - web
- `StatefulSet:` Databases
 - mongodb
 - mysql

<a name="autoscaling"></a>
## Autoscaling (autoscaling/v2)
- `HorizontalPodAutoscaler:` Configured for all services
 - minReplicas: 1
 - maxReplicas: 5
 - CPU target: 70-80%
 - Memory target: 70-80%

<a name="storage"></a>
## Storage Configuration
- `StorageClass:` gp3-default
- `PersistentVolumeClaim:` 
 - Size: 1Gi
 - AccessMode: ReadWriteOnce
 - Used by MongoDB and MySQL

<a name="resilience-features"></a>
## Resilience Features
- `Init Containers:` 
 - wait-for-mysql in shipping service
- `Resource Management:` Configured for each service
- `Health Checks:` 
 - Liveness Probe: HTTP, TCP, and Exec checks
 - Readiness Probe: HTTP, TCP, and Exec checks

<a name="configuration-security"></a>
## Configuration and Security
- `Environment Variables:` 
 - ConfigMaps
 - Secrets
 - Direct variables
- `Volume Management:` 
 - PVC for MongoDB and MySQL
 - Volume Mounts configured

<a name="service-distribution"></a>
## Service Distribution
- `Stateful Services:`
 - MongoDB: StatefulSet + Headless + ClusterIP
 - MySQL: StatefulSet + Headless + ClusterIP
- `Stateless Services:`
 - Redis: Deployment + ClusterIP
 - RabbitMQ: Deployment + ClusterIP (ports 5672, 15672)
 - Microservices: Deployments + ClusterIP (port 8080)

<a name="networking"></a>
## Networking
- `Ingress:` 
 - Host: robotshop.andherson33.click
 - SSL/TLS configured
 - Nginx Ingress Controller (class: nginx-external)
 - AWS Certificate configured
