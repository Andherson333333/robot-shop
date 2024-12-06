## Índice de contenidos
* [Jaeger con Persistencia en Kubernetes](#item1)
* [Descripción](#item2)
* [Requistos](#item3)
* [Instalacion](#item4)
* [Verificacion](#item5)
* [Componentes](#item6)

<a name="item1"></a>
# Jaeger con Persistencia en Kubernetes

Este repositorio contiene la configuración necesaria para desplegar Jaeger con almacenamiento persistente en Kubernetes, integrado con Istio para la recopilación de telemetría.

<a name="item2"></a>
## Descripción

Esta implementación incluye:
- Jaeger All-in-One con almacenamiento Badger persistente
- Integración con Istio para recopilación de telemetría
- Servicios para Zipkin, recopilación y consulta
- Persistencia mediante NFS

<a name="item3"></a>
## Reequisitos

- Kubernetes cluster
- Istio instalado y configurado
- Servidor NFS configurado y accesible (172.16.0.142)
- Directorio NFS creado (/data/jagger)

<a name="item4"></a>
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
<a name="item5"></a>
## Verificacion

pod y svc
![jagger-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-1.png)

Dashbord
![jagger-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-2.png)
![jagger-3](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-jagger-3.png)

<a name="item6"></a>
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





