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

![estructura](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

<a name="item3"></a>
## Requistos

- Cluster Kubernetes funcionando (v1.19+)
- kubectl instalado y configurado
- Soporte para PersistentVolumes (bases de datos)

<a name="item4"></a>
## Despligue


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
