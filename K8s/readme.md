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

