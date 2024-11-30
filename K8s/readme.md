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

## Requistos

- Cluster Kubernetes funcionando (v1.19+)
- kubectl instalado y configurado
- 4GB RAM disponible en el cluster
- Soporte para LoadBalancer (acceso al frontend)
- Soporte para PersistentVolumes (bases de datos)
  
## Despligue

Si quieres desplegar toda la aplicación de una vez:

```
kubectl apply -f .
```

Si prefieres más control sobre el proceso:

1. Crear Namespace y Configuraciones Base
2. Bases de Datos y Almacenamiento
3. Message Broker
4. Microservicios de la Aplicación
5. Frontend Web




## Tecnologías de Kubernetes Utilizadas

### Core Resources (v1)
- **Namespace**: Aislamiento de recursos y organización del proyecto
- **ConfigMap**: Configuraciones no sensibles de la aplicación
- **Secret**: Almacenamiento seguro de credenciales y datos sensibles
- **Service**: Exposición y descubrimiento de servicios
  - ClusterIP: Comunicación interna
  - LoadBalancer: Exposición externa (Web UI)
  - Headless: Usado por StatefulSets (MongoDB, MySQL)
- **PersistentVolume (PV)**: Almacenamiento persistente para bases de datos
- **PersistentVolumeClaim (PVC)**: Solicitudes de almacenamiento para MongoDB y MySQL

### Workloads (apps/v1)
- **Deployment**: Aplicaciones stateless
  - Redis, RabbitMQ
  - Servicios web (cart, catalogue, payment, etc.)
- **StatefulSet**: Aplicaciones stateful
  - MongoDB
  - MySQL

### Autoscaling (autoscaling/v2)
- **HorizontalPodAutoscaler (HPA)**: Autoescalado automático
  - Configurado para todos los servicios
  - Basado en CPU (70%) y Memoria (70%)
  - Escala de 1 a 5 réplicas

### Características de Resiliencia
- **Init Containers**: Verificación de dependencias
- **Resource Management**:
  - Requests: Recursos mínimos garantizados
  - Limits: Límites máximos de recursos
- **Health Checks**:
  - Liveness Probe: Verificación de salud
  - Readiness Probe: Verificación de disponibilidad

### Configuración y Seguridad
- **Environment Variables**: Variables de entorno desde:
  - ConfigMaps
  - Secrets
  - Valores directos
- **Volume Management**: 
  - PersistentVolumes
  - Volume Mounts
  - Volume Claims

### Distribución de Servicios
- **Stateful Services**:
  - MongoDB (StatefulSet + Headless Service)
  - MySQL (StatefulSet + Headless Service)
- **Stateless Services**:
  - Redis (Deployment + ClusterIP)
  - RabbitMQ (Deployment + ClusterIP)
  - Microservicios (Deployments + ClusterIP)
  - Web UI (Deployment + LoadBalancer)
