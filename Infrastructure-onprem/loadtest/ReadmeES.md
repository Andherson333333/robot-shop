# Configuraciones de Pruebas de Carga para Robot Shop

Este repositorio contiene diversas configuraciones de pruebas de carga para la aplicación de microservicios Robot Shop utilizando Jobs de Kubernetes. Las pruebas utilizan tanto Fortio como curl para generar diferentes patrones de carga.

## Descripción General

El conjunto de pruebas de carga incluye múltiples configuraciones para evaluar diferentes componentes de la aplicación Robot Shop:
- Pruebas de carga basadas en TCP con diferentes intensidades
- Pruebas de endpoints HTTP
- Monitoreo continuo de servicios
- Pruebas específicas de endpoints de productos

## Configuraciones Disponibles

### 1. Prueba de Alta Carga (loadtestCarga.yaml)
Una prueba de carga integral que se dirige a múltiples servicios con diferentes intensidades:
- Servicio Web: 20 QPS con 10 conexiones concurrentes
- Servicio de Catálogo: 50 QPS con 15 conexiones concurrentes
- Servicio de Carrito: 30 QPS con 8 conexiones concurrentes
- Servicio de Usuario: 15 QPS con 5 conexiones concurrentes
- Servicio de Envío: 10 QPS con 3 conexiones concurrentes
- Servicio de Pago: 25 QPS con 12 conexiones concurrentes

Todos los contenedores están limitados en recursos con:
- CPU: 100m (solicitud) / 200m (límite)
- Memoria: 128Mi (solicitud) / 256Mi (límite)

### 2. Prueba de Carga TCP Básica (loadtestTCP.yaml)
Una configuración de prueba de carga más ligera con parámetros uniformes en todos los servicios:
- 5 QPS
- 2 conexiones concurrentes
- Duración de 30 segundos
- Prueba los servicios web, catálogo, carrito, usuario, envío y pago

### 3. Prueba de Endpoints HTTP (loadtHTTP.yaml)
Enfocada en probar endpoints HTTP específicos:
- Pruebas de acceso web externo
- Pruebas de endpoints específicos para productos: RED, EMM, SHCE
- Incluye registro detallado con modo verbose de curl

### 4. Monitoreo de Servicios (loadtestError.yaml)
Monitoreo continuo de todos los endpoints de servicios con:
- Sondeo regular de todos los servicios
- Intervalo de 0.5 segundos entre ciclos de prueba
- Monitorea los servicios web, catálogo, carrito, usuario, envío, pago, calificaciones y despacho

