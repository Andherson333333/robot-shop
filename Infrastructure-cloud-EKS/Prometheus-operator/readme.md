# Monitoreo con Prometheus y Grafana para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Acceso](#acceso)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa el stack de monitoreo Prometheus-Grafana en el clúster EKS, incluyendo monitoreo específico para componentes de Istio.

<a name="requisitos"></a>
## Requisitos Previos
- EKS Cluster desplegado
- Nginx Ingress Controller interno configurado
- StorageClass gp3-default disponible
- Istio instalado (para monitores de Istio)
- Dominios configurados:
 - prometheus.andherson33.click
 - graphana.andherson33.click
- Terraform >= 1.0
- kubectl
- helm

<a name="componentes"></a>
## Componentes
El despliegue configura:
- Prometheus Stack en namespace monitoring
- Grafana con persistencia
- ServiceMonitor para componentes de Istio
- PodMonitor para proxies Envoy
- Ingress para Prometheus y Grafana

<a name="configuracion"></a>
## Configuración

### Prometheus Stack

Configuración:
- Nombre: prometheus
- Chart: kube-prometheus-stack
- Versión: 68.2.1
- Namespace: monitoring
- Retención: 15 días
- Almacenamiento: 10Gi (gp3-default)

### Grafana
Configuración:
- Persistencia: Habilitada
- StorageClass: gp3-default
- Tamaño: 10Gi

### Ingress
Prometheus:
- Hostname: prometheus.andherson33.click
- Clase: nginx-internal
- Puerto: 9090

Grafana:
- Hostname: graphana.andherson33.click
- Clase: nginx-internal
- Puerto: 80

### Monitores Istio

PodMonitor (Envoy):
- Namespace: istio-system
- Intervalo: 15s
- Path: /stats/prometheus

ServiceMonitor (Control Plane):
- Namespace: istio-system
- Intervalo: 15s
- Componentes: pilot

<a name="despliegue"></a>
## Despliegue


<a name="acceso"></a>
## Acceso

Las interfaces estarán disponibles internamente en:

Prometheus: https://prometheus.andherson33.click
Grafana: https://graphana.andherson33.click

Credenciales por defecto de Grafana:

Usuario: admin
Contraseña: prom-operator

<a name="verificacion"></a>
## Verificación

# Verificar pods
kubectl get pods -n monitoring

# Verificar servicios
kubectl get svc -n monitoring

# Verificar ingress
kubectl get ingress -n monitoring

# Verificar PVCs
kubectl get pvc -n monitoring

# Verificar monitores
kubectl get servicemonitor -n istio-system
kubectl get podmonitor -n istio-system




