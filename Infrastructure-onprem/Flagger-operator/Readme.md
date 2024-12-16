## Flagger Canary Deployment Demo
Este repositorio contiene la configuración necesaria para implementar despliegues canary utilizando Flagger en Kubernetes con Istio como proveedor de service mesh.

## Índice de contenidos
* [Flagger](#item1)
* [Canary](#item2)
* [Requistos](#item3)
* [Instalacion](#item4)
* [Trafico](#item5)
* [Verificacion](#item6)

<a name="item1"></a>
## Flagger
Flagger es una herramienta de entrega progresiva para Kubernetes que automatiza el proceso de despliegue canary. En esta implementación, está configurado para trabajar con Istio como proveedor de service mesh y utiliza Prometheus para la recolección de métricas.
Características principales de nuestra configuración:

Monitoreo de métricas a través de Prometheus
Integración con Istio
Gestión automatizada de recursos
Sistema de métricas habilitado

<a name="item2"></a>
## Canary Deployments
Los despliegues canary son una estrategia de lanzamiento que permite probar nuevas versiones de software con una porción limitada de usuarios reales antes de un despliegue completo. Similar a los canarios que usaban los mineros para detectar gases tóxicos, esta técnica actúa como sistema de alerta temprana ante posibles problemas.

La nueva versión recibe inicialmente un pequeño porcentaje del tráfico (10%), que va aumentando gradualmente mientras se monitorizan métricas clave como errores y latencia. Si todo funciona correctamente, se incrementa el tráfico; si hay problemas, se revierte automáticamente.
En nuestra implementación:

- Análisis cada 30 segundos
- Máximo 50% del tráfico para la versión canary
- Incrementos del 10%
- Monitoreo de métricas de éxito y rendimiento

Esta estrategia nos permite desplegar nuevas versiones de forma segura y controlada, minimizando riesgos para nuestros usuarios.

- Tasa de éxito de requests (mínimo 99%)
- Duración de requests (máximo 500ms)

<a name="item3"></a>
## Requistos

- Kubernetes cluster
- Istio instalado y configurado
- Prometheus operativo en el namespace monitoring
- Helm (para la instalación de Flagger)

<a name="item4"></a>
## Instalacion

1. Agregar los repositorios helm y actualizar
2. Instalar el helm con el archivo values.yaml
3. Verificar instalacion

<a name="item5"></a>
## Trafico

El repositorio incluye un Job de prueba de carga (loadtesthttp.yaml) que simula tráfico hacia la aplicación:

- Realiza pruebas de acceso web externo
- Ejecuta solicitudes a productos específicos
- Mantiene un flujo constante de tráfico para análisis

<a name="item6"></a>
## Verificacion
