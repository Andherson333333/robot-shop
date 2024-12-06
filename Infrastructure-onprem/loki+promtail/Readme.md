## Indice
* [Configuración de Logging con Loki y Promtail para Istio](#item1)
* [Requisitos](#item2)
* [Arquitectura](#item3)
* [Instalación de lokin](#item4)
* [Verificacion de loki](#item5)
* [Configuración e Instalación de Promtail](#item6)
* [Instalación promtail con helm](#item7)
* [Verificacion promtail](#item8)
* [Configuracion Graphana](#item9)

<a name="item1"></a>
# Configuración de Logging con Loki y Promtail para Istio

Este repositorio contiene la configuración para implementar un stack de logging completo usando Loki como backend de almacenamiento y Promtail como agente de recolección de logs, optimizado para trabajar con Istio service mesh.

<a name="item2"></a>
## Requisitos 

- Cluster de Kubernetes
- Service mesh Istio instalado
- Servidor NFS configurado y accesible
- Helm 3.x (para Promtail)
- StorageClass para NFS configurada
  
<a name="item3"></a>
## Arquitectura

- `Loki:` Sistema de agregación de logs instalado en el namespace `istio-system` (instalado via manifiestos)
- `Promtail:` Agente de recolección de logs en namespace dedicado (instalado via Helm)
- `Almacenamiento:` NFS para persistencia de datos (10GB)
- `Service Mesh:` Integración con Istio

<a name="item4"></a>
## Instalación de loki

1. Configuración de Almacenamiento NFS ,crear el PersistentVolume para Loki
```
kubectl apply -f pv-loki.yaml
```
2. Desplegar manifiesto loki.yaml se modifico para crear el pv(fuente original https://github.com/istio/istio/blob/master/samples/addons/loki.yaml)
```
kubectl apply -f loki.yaml
```
<a name="item5"></a>
## Verificacion de loki

pv

![loki-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-3.png)

pod y svc
![loki-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-2.png)


<a name="item6"></a>
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

<a name="item7"></a>
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

<a name="item8"></a>
## Verificacion promtail

 Helm
![promtail-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-promtail-2.png)

pod y svc
![promtail-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-promtail-1.png)

<a name="item9"></a>
# Configuracion Graphana

Luego de configurar se verifica que esta funcionando , se puede hacer de varias maneras pero se va realizar a traves graphana 

1. Se agrega al data source Loki
2. Luego se realiza alguna consulta de prueba
3. Creacion query para el dashbord
```
{namespace="robot-shop", pod=~"web.*"}
{namespace="robot-shop", pod=~"cart.*"}
{namespace="robot-shop", pod=~"catalogue.*"}
{namespace="robot-shop", pod=~"user.*"}
{namespace="robot-shop", pod=~"payment.*"}
{namespace="robot-shop", pod=~"shipping.*"}
{namespace="robot-shop", pod=~"ratings.*"}
{namespace="robot-shop", pod=~"dispatch.*"}
{namespace="robot-shop", pod=~"mysql.*"}
{namespace="robot-shop", pod=~"mongodb.*"}
{namespace="robot-shop", pod=~"redis.*"}
{namespace="robot-shop", pod=~"rabbitmq.*"}
```
4. Creacion dashbord para graphana para la aplicacion
![graphana-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-loki-1.png)





