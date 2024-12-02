# Robot Shop Kubernetes Manifests

Este repositorio contiene los manifiestos de Kubernetes necesarios para desplegar la aplicación Robot Shop, una tienda de robots de demostración que utiliza una arquitectura de microservicios.

## Estructura del Proyecto

<pre>
K8s/
├── app-services/          # Servicios principales de la aplicación
│   ├── namespace.yaml
│   ├── cart/             # Servicio de carrito
│   ├── catalogue/        # Catálogo de productos
│   ├── payment/          # Servicio de pagos
│   ├── ratings/          # Sistema de calificaciones
│   ├── shipping/         # Servicio de envíos
│   ├── user/             # Gestión de usuarios
│   └── web/              # Frontend web
├── mongodb/              # Base de datos MongoDB
├── mysql/                # Base de datos MySQL
├── rabbitmq/            # Message Broker RabbitMQ
└── redis/               # Cache Redis
</pre>

![estructura](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

## Requistos

- Cluster Kubernetes funcionando (v1.19+)
- kubectl instalado y configurado
- Soporte para PersistentVolumes (bases de datos)
  
## Despligue

Si quieres desplegar toda la aplicación de una vez:

```
kubectl apply -f .
```

Si prefieres más control sobre el proceso:

1. Crear Namespace y Configuraciones Base
```
kubectl apply -f app-services/namespace.yaml
```
2. Bases de Datos y Almacenamiento
```
# MongoDB
kubectl apply -f mongodb/mongodb-pv.yaml
kubectl apply -f mongodb/mongodb-services.yaml
kubectl apply -f mongodb/mongodb-statefulset.yaml

# MySQL
kubectl apply -f mysql/mysql-configmap.yaml
kubectl apply -f mysql/mysql-secret.yaml
kubectl apply -f mysql/mysql-pv.yaml
kubectl apply -f mysql/mysql-services.yaml
kubectl apply -f mysql/mysql-statefulset.yaml

# Redis
kubectl apply -f redis/redis-deployment.yaml
kubectl apply -f redis/redis-service.yaml
```

3. Message Broker
```
# Redis
kubectl apply -f redis/redis-deployment.yaml
kubectl apply -f redis/redis-service.yaml
```
4. Microservicios de la Aplicación
```
# Catalogue
kubectl apply -f app-services/catalogue/
# Cart
kubectl apply -f app-services/cart/
# User
kubectl apply -f app-services/user/
# Payment
kubectl apply -f app-services/payment/
# Shipping
kubectl apply -f app-services/shipping/
# Ratings
kubectl apply -f app-services/ratings/
```
5. Frontend Web
```
kubectl apply -f app-services/web/
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
