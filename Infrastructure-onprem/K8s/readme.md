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

![estructura](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

<a name="item3"></a>
## Requistos

- Cluster Kubernetes funcionando (v1.19+)
- kubectl instalado y configurado
- Soporte para PersistentVolumes (bases de datos)

<a name="item4"></a>
## Despligue

1. Crear el namespace
```
kubectl apply -f manifiestos/namespace.yaml
```
2. Despliegue los servicios de base de datos (MongoDB y MySQL)
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
![pod-service](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-6.png)

- deployment y statefulset
![deployment](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-7.png)

- Hpa
![HPA](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-5.png)

- PV 
![pv](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-8.png)

<a name="item6"></a>
## Tecnologías de Kubernetes Utilizadas

### Core Resources (v1)
- `Namespace:` Aislamiento de recursos y organización del proyecto
- `ConfigMap:` Configuraciones no sensibles de la aplicación
- `Secret:` Almacenamiento seguro de credenciales y datos sensibles
- `Service:` Exposición y descubrimiento de servicios
  - ClusterIP: Comunicación interna
  - LoadBalancer: Exposición externa (Web UI)
  - Headless: Usado por StatefulSets (MongoDB, MySQL)
- `PersistentVolume (PV):` Almacenamiento persistente para bases de datos
- `PersistentVolumeClaim (PVC):` Solicitudes de almacenamiento para MongoDB y MySQL

### Workloads (apps/v1)
- `Deployment:` Aplicaciones stateless
  - Redis, RabbitMQ
  - Servicios web (cart, catalogue, payment, etc.)
- `StatefulSet:` Aplicaciones stateful
  - MongoDB
  - MySQL

### Autoscaling (autoscaling/v2)
- `HorizontalPodAutoscaler (HPA):` Autoescalado automático
  - Configurado para todos los servicios
  - Basado en CPU (70%) y Memoria (70%)
  - Escala de 1 a 5 réplicas

### Características de Resiliencia
- `Init Containers:` Verificación de dependencias
- `Resource Management:`
  - Requests: Recursos mínimos garantizados
  - Limits: Límites máximos de recursos
- `Health Checks:`
  - Liveness Probe: Verificación de salud
  - Readiness Probe: Verificación de disponibilidad

### Configuración y Seguridad
- `Environment Variables:` Variables de entorno desde:
  - ConfigMaps
  - Secrets
  - Valores directos
- `Volume Management:` 
  - PersistentVolumes
  - Volume Mounts
  - Volume Claims

### Distribución de Servicios
- `Stateful Services:`
  - MongoDB (StatefulSet + Headless Service)
  - MySQL (StatefulSet + Headless Service)
- `Stateless Services:`
  - Redis (Deployment + ClusterIP)
  - RabbitMQ (Deployment + ClusterIP)
  - Microservicios (Deployments + ClusterIP)
  - Web UI (Deployment + LoadBalancer)
