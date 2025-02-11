# Despliegue de Robot Shop en Kubernetes

## Descripción General
Este repositorio contiene los manifiestos de Kubernetes para desplegar una aplicación Robot Shop basada en microservicios. La aplicación está compuesta por múltiples servicios que incluyen interfaz web, catálogo, carrito, gestión de usuarios, procesamiento de pagos y más.

## Arquitectura
La aplicación está compuesta por los siguientes microservicios:
- Frontend Web
- Servicio de Catálogo
- Servicio de Usuarios
- Servicio de Carrito
- Servicio de Envíos
- Servicio de Pagos
- Servicio de Calificaciones
- Servicio de Despacho
- Infraestructura de Soporte:
 - MongoDB
 - MySQL
 - Redis
 - RabbitMQ

## Requisitos Previos
- Cluster de Kubernetes
- Kubectl configurado para interactuar con tu cluster
- Clase de almacenamiento `gp3-default` disponible en tu cluster
- Controlador Nginx Ingress instalado
- Nombre de dominio configurado (actualmente configurado como robotshop.andherson33.click)

## Características
- Aislamiento de namespace con istio-injection habilitado
- Almacenamiento persistente para bases de datos
- Escalado Horizontal de Pods (HPA) para todos los servicios
- Verificaciones de salud y sondas de disponibilidad
- Límites y solicitudes de recursos
- ConfigMaps y Secrets para gestión de configuración
- Configuración de Ingress para acceso externo

## Configuración
La aplicación utiliza varios ConfigMaps y Secrets para su configuración:
- Configuraciones de MySQL
- Configuraciones del servicio de envíos
- Configuraciones del servicio de calificaciones
- Configuraciones del servicio web
- Varias credenciales de bases de datos (almacenadas en Secrets)

## Despliegue
1. Clonar este repositorio
2. Aplicar los manifiestos:
```bash
kubectl apply -f robot-shop.yaml
```

# Configuración de Servicios

## Bases de Datos
- **MongoDB**: Desplegado como StatefulSet con almacenamiento persistente.  
- **MySQL**: Desplegado como StatefulSet con almacenamiento persistente.  
- **Redis**: Desplegado como servicio sin estado.  
- **RabbitMQ**: Broker de mensajes para comunicación entre servicios.  

## Servicios de Aplicación
Cada servicio está configurado con:  
- Límites y solicitudes de recursos.  
- Sondas de vida y disponibilidad.  
- Escalado automático (HPA).  
- Descubrimiento de servicios vía Servicios de Kubernetes.  

## Escalado
Todos los servicios están configurados con **HorizontalPodAutoscaler**:  
- **Réplicas mínimas**: 1  
- **Réplicas máximas**: 5  
- **Utilización objetivo de CPU**: 70%  
- **Utilización objetivo de memoria**: 70%  

## Almacenamiento
La aplicación utiliza almacenamiento persistente para:  
- **MongoDB**: 1Gi  
- **MySQL**: 1Gi  

## Red
- **Comunicación interna**: Servicios ClusterIP.  
- **Acceso externo**: Nginx Ingress.  
- **Dominio**: [robotshop.andherson33.click](http://robotshop.andherson33.click)  

## Imágenes
La aplicación utiliza imágenes personalizadas alojadas en **Docker Hub** bajo el repositorio `andherson1039`.  

## Monitoreo
Se implementan verificaciones de salud para todos los servicios con:  
- Sondas de vida.  
- Sondas de disponibilidad.  
- Endpoints personalizados de verificación de salud.  









