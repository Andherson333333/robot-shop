# Configuración de Logging con Loki y Promtail para Istio

Este repositorio contiene la configuración para implementar un stack de logging completo usando Loki como backend de almacenamiento y Promtail como agente de recolección de logs, optimizado para trabajar con Istio service mesh.

## Arquitectura

- **Loki**: Sistema de agregación de logs instalado en el namespace `istio-system` (instalado via manifiestos)
- **Promtail**: Agente de recolección de logs en namespace dedicado (instalado via Helm)
- **Almacenamiento**: NFS para persistencia de datos (10GB)
- **Service Mesh**: Integración con Istio

## Requisitos Previos

- Cluster de Kubernetes
- Service mesh Istio instalado
- Servidor NFS configurado y accesible
- Helm 3.x (para Promtail)
- StorageClass para NFS configurada

## Instalación de loki

### 1. Configuración de Almacenamiento NFS

Crear el PersistentVolume para Loki
```
kubectl apply -f pv-loki.yaml
```

# Configuración e Instalación de Promtail

## Recolección y Etiquetado de Logs

La configuración incluye reglas especializadas de reetiquetado que:

### 1. Captura de Metadatos Kubernetes
- Namespace del pod
- Nombre del pod 
- Nombre del contenedor

### 2. Clasificación de Logs
- `envoy`: Logs de contenedores proxy Istio
- `application`: Logs de contenedores de aplicación

## Conexión con Loki

- Endpoint: `http://loki.istio-system.svc.cluster.local:3100/loki/api/v1/push`
- Service discovery mediante DNS interno del cluster

## Monitoreo

- ServiceMonitor habilitado para Prometheus
- Métricas de rendimiento de Promtail

## Instalación promtail con helm

Para instalar Promtail usando esta configuración:
1. Crear un archivo `values.yaml` con la configuración proporcionada
2. Crear el namespace para Promtail:
```
kubectl create namespace promtail
```
3. Instalar el repo de promtail
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```
4. Instalar protail con helm
```
helm install promtail grafana/promtail -f values.yaml -n istio-system
```



