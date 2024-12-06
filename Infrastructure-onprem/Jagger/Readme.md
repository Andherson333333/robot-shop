# Jaeger con Persistencia en Kubernetes

Este repositorio contiene la configuración necesaria para desplegar Jaeger con almacenamiento persistente en Kubernetes, integrado con Istio para la recopilación de telemetría.

## Descripción

Esta implementación incluye:
- Jaeger All-in-One con almacenamiento Badger persistente
- Integración con Istio para recopilación de telemetría
- Servicios para Zipkin, recopilación y consulta
- Persistencia mediante NFS

## Reequisitos

- Kubernetes cluster
- Istio instalado y configurado
- Servidor NFS configurado y accesible (172.16.0.142)
- Directorio NFS creado (/data/jagger)

## Instalacion

1. Aplicar la configuración de almacenamiento
```
kubectl apply -f jagger-deploy-svc.yaml
```
2. Aplicar los manifiestos de Jaeger
```
kubectl apply -f jagger-pv-pvc.yaml
```
3. Aplicar la configuración de telemetría de Istio
```
kubectl apply -f telemetry.yaml
```

## Verificacion

## Componentes

### Almacenamiento Persistente

#### PersistentVolume
- Tipo: NFS
- Capacidad: 10Gi
- Política de reclamación: Retain
- Servidor NFS: 172.16.0.142
- Ruta NFS: /data/jagger
- Modo de acceso: ReadWriteOnce

#### PersistentVolumeClaim
- Namespace: istio-system
- Capacidad solicitada: 10Gi
- StorageClass: nfs
- Modo de acceso: ReadWriteOnce

### Deployment
- Utiliza la imagen `jaegertracing/all-in-one:1.58`
- Configurado con almacenamiento Badger
- Retención de datos configurada a 24 horas
- Mantenimiento programado cada 15 minutos

### Servicios
1.`tracing` (Puerto 80, 16685)
   - Interfaz de usuario y consultas
   - Soporte para gRPC

2. `zipkin` (Puerto 9411)
   - Compatibilidad con formato Zipkin

3. `jaeger-collector` (Puertos múltiples)
   - HTTP: 14268
   - gRPC: 14250
   - Zipkin: 9411
   - OpenTelemetry: 4317, 4318

## Configuración de Istio Telemetry

1. `Recopilación de Datos`
   - Istio captura automáticamente métricas, trazas y logs de todo el tráfico que pasa por el mesh
   - Los sidecars de Envoy actúan como puntos de recopilación de datos





