# Configuración de Promtail para Logging con Istio

Este repositorio contiene archivos de configuración para configurar Promtail con Istio para recolectar y enviar logs a Loki. La configuración está diseñada para funcionar dentro de un cluster de Kubernetes con el service mesh de Istio.

## Descripción General

Esta configuración permite la recolección de logs de pods habilitados con Istio, con reglas específicas de reetiquetado para categorizar logs tanto del proxy Envoy (istio-proxy) como de contenedores de aplicaciones.

## Requisitos Previos

- Cluster de Kubernetes
- Service mesh Istio instalado
- Loki instalado en el namespace `istio-system`
- Helm (para el despliegue)

## Detalles de Configuración

### Recolección y Etiquetado de Logs

La configuración incluye reglas especializadas de reetiquetado que:

1. Capturan metadatos estándar de Kubernetes:
  - Namespace
  - Nombre del pod
  - Nombre del contenedor

2. Clasifican los logs en diferentes tipos:
  - `envoy`: Logs de los contenedores del proxy Istio
  - `application`: Logs de todos los demás contenedores

### Conexión con Loki

- Promtail está configurado para enviar logs a Loki en: `http://loki.istio-system.svc.cluster.local:3100/loki/api/v1/push`
- El servicio utiliza el DNS del cluster de Kubernetes para el descubrimiento de servicios

### Monitoreo

- ServiceMonitor está habilitado para la integración con Prometheus
- Se pueden recolectar métricas para monitorear el rendimiento de Promtail

## Instalación

Para instalar Promtail usando esta configuración:

1. Crear un archivo `values.yaml` con la configuración proporcionada
2. Instalar usando Helm:

```
helm install promtail grafana/promtail -f values.yaml -n istio-system
```



