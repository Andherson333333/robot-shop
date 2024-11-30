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

## Componentes

### Bases de Datos
- **MongoDB**: Base de datos NoSQL para el catálogo de productos
- **MySQL**: Base de datos relacional para usuarios y envíos
- **Redis**: Sistema de caché para el carrito de compras

### Message Broker
- **RabbitMQ**: Sistema de mensajería para comunicación asíncrona

### Microservicios
- **Cart**: Gestión del carrito de compras
- **Catalogue**: Gestión del catálogo de productos
- **Payment**: Procesamiento de pagos
- **Ratings**: Sistema de calificaciones
- **Shipping**: Gestión de envíos
- **User**: Gestión de usuarios
- **Web**: Interfaz web de usuario

## Requisitos Previos

- Kubernetes v1.19 o superior
- Kubectl configurado para tu cluster
- Almacenamiento disponible para PersistentVolumes

## Instalación

1. Crear el namespace:
```
kubectl apply -f app-services/namespace.yaml

# MongoDB
kubectl apply -f mongodb/

# MySQL
kubectl apply -f mysql/

# Redis
kubectl apply -f redis/

# Rabbitmq
kubectl apply -f rabbitmq/

kubectl apply -f app-services/cart/
kubectl apply -f app-services/catalogue/
kubectl apply -f app-services/payment/
kubectl apply -f app-services/ratings/
kubectl apply -f app-services/shipping/
kubectl apply -f app-services/user/
kubectl apply -f app-services/web/

```




