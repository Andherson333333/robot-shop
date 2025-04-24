## Indice

## Índice de contenidos
* [Robot Shop Kubernetes Manifests](#item1)
* [Estructura del Proyecto](#item2)
* [Requistos](#item3)
* [Despligue](#item4)
* [Verificacion](#item5)
* [Tecnologías de Kubernetes Utilizadas](#item6)

<a name="item1"></a>
# Robot Shop Kubernetes Manifests

Este repositorio contiene los manifiestos de Kubernetes necesarios para desplegar la aplicación Robot Shop, una tienda de robots de demostración que utiliza una arquitectura de microservicios.

<a name="item2"></a>
## Estructura del Proyecto

El proyecto está organizado en un directorio principal que contiene todos los manifiestos de Kubernetes necesarios para el despliegue de la aplicación Robot Shop:

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

![estructura](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

![estructura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-aplicacion/K8s/imagenes/robot-shop-5.png)

<a name="item3"></a>
## Requistos

- Cluster de Kubernetes
- Kubectl configurado para interactuar con tu cluster
- Clase de almacenamiento `gp3-default` disponible en tu cluster
- Controlador Nginx Ingress instalado
- Nombre de dominio configurado (actualmente configurado como robotshop.andherson33.click)

<a name="item4"></a>
## Despligue

1. Crear el namespace
```
kubectl apply -f manifiestos/namespace.yaml
```
2. Despliegue los servicios de base de datos (MongoDB y MySQL)
```
kubectl apply -f manifiestos/mongodb-service.yaml
kubectl apply -f manifiestos/mongodb-statefulset.yaml
kubectl apply -f manifiestos/mysql-configmap.yaml
kubectl apply -f manifiestos/mysql-secret.yaml
kubectl apply -f manifiestos/mysql-service.yaml
kubectl apply -f manifiestos/mysql-statefulset.yaml
```
3. Despliegue los servicios de infraestructura (Redis y RabbitMQ):
```
kubectl apply -f manifiestos/redis-deployment.yaml
kubectl apply -f manifiestos/redis-service.yaml
kubectl apply -f manifiestos/rabbitmq-deployment.yaml
kubectl apply -f manifiestos/rabbitmq-service.yaml
```
4. Despliegue los microservicios de la aplicación:
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
5. Alternativamente, puede desplegar toda la aplicación con un solo comando:
```
kubectl apply -f manifiestos/
```
## Verificacion

- Pod y servicio
![pod-service](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-aplicacion/K8s/imagenes/robot-shop-eks-2.png)


<a name="item6"></a>
## Tecnologías de Kubernetes Utilizadas

## Core Resources (v1)
- `Namespace:` robot-shop con istio-injection habilitado
- `ConfigMap:` 
 - mysql-config: Configuración de base de datos
 - shipping-config: Configuración del servicio de envíos
 - ratings-config: Configuración del servicio de calificaciones
 - web-config: Configuración de endpoints de servicios
- `Secret:` 
 - mysql-secrets
 - shipping-secrets
 - ratings-secrets
- `Service:` 
 - ClusterIP: Servicios internos (redis, mysql, mongodb, etc)
 - Headless: Para StatefulSets (mongodb-headless, mysql-headless)
- `PersistentVolumeClaim:` 
 - mongodb-pvc
 - mysql-pvc

<a name="workloads"></a>
## Workloads (apps/v1)
- `Deployment:` Servicios stateless
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
- `StatefulSet:` Bases de datos
 - mongodb
 - mysql

<a name="autoscaling"></a>
## Autoscaling (autoscaling/v2)
- `HorizontalPodAutoscaler:` Configurado para todos los servicios
 - minReplicas: 1
 - maxReplicas: 5
 - CPU target: 70-80%
 - Memory target: 70-80%

<a name="almacenamiento"></a>
## Configuración de Almacenamiento
- `StorageClass:` gp3-default
- `PersistentVolumeClaim:` 
 - Tamaño: 1Gi
 - AccessMode: ReadWriteOnce
 - Usado por MongoDB y MySQL

<a name="caracteristicas-resiliencia"></a>
## Características de Resiliencia
- `Init Containers:` 
 - wait-for-mysql en shipping service
- `Resource Management:` Configurado para cada servicio
- `Health Checks:` 
 - Liveness Probe: HTTP, TCP y Exec checks
 - Readiness Probe: HTTP, TCP y Exec checks

<a name="configuracion-seguridad"></a>
## Configuración y Seguridad
- `Environment Variables:` 
 - ConfigMaps
 - Secrets
 - Variables directas
- `Volume Management:` 
 - PVC para MongoDB y MySQL
 - Volume Mounts configurados

<a name="distribucion-servicios"></a>
## Distribución de Servicios
- `Stateful Services:`
 - MongoDB: StatefulSet + Headless + ClusterIP
 - MySQL: StatefulSet + Headless + ClusterIP
- `Stateless Services:`
 - Redis: Deployment + ClusterIP
 - RabbitMQ: Deployment + ClusterIP (puertos 5672, 15672)
 - Microservicios: Deployments + ClusterIP (puerto 8080)

<a name="networking"></a>
## Networking
- `Ingress:` 
 - Host: robotshop.andherson33.click
 - SSL/TLS configurado
 - Nginx Ingress Controller (clase: nginx-external)
 - AWS Certificado configurado










