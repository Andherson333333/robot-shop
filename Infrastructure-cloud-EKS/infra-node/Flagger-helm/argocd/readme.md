# Flagger Helm Chart Configuración

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura de Archivos](#estructura)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)
* [Acceso](#acceso)
  
<a name="descripcion"></a>
## Descripción General
Este módulo implementa Flagger en el clúster Kubernetes, proporcionando una herramienta de entrega progresiva (progressive delivery) que automatiza el proceso de lanzamiento para aplicaciones. Flagger reduce el riesgo de introducir nuevas versiones en producción mediante el cambio gradual del tráfico hacia la nueva versión mientras monitorea métricas y ejecuta pruebas de conformidad.

<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes >=1.16.0
- Istio, Linkerd, App Mesh, NGINX o Contour instalado
- Para Istio, se requiere v1.0.0 o más reciente con Prometheus
- Prometheus configurado en la URL especificada
- Argocd desplegado
- Helm >= 3.0
- kubectl

<a name="componentes"></a>
## Componentes
El despliegue configura:
- Flagger en namespace dedicado
- Controlador de despliegue progresivo
- Monitoreo de pods a través de PodMonitor
- Integración con Istio para control de tráfico

<a name="estructura"></a>
## Estructura de Archivos
```
.
├── argocd-flagger.yaml         # Despligue para argocd

```

<a name="configuracion"></a>
## Configuración
### Flagger Helm Chart
Configuración:
- Nombre: flagger
- Repositorio: https://flagger.app
- Versión: 1.40.0
- Tipo: application

### Proveedor de Malla de Servicios
Configuración:
- Proveedor: istio
- Servidor de métricas: http://prometheus-stack-kube-prom-prometheus.monitoring:9090
- Intervalo de métricas: 15s
- Intervalo de telemetría: 5s

### Recursos
Configuración:
- Solicitudes:
  - CPU: 100m
  - Memoria: 128Mi
- Límites:
  - CPU: 1000m
  - Memoria: 512Mi

### Monitoreo
Configuración:
- PodMonitor: Habilitado
- Métricas: Habilitadas
- Nivel de logs: info

### Programación
Configuración:
- Tolerancias: Infraestructura (PreferNoSchedule)
- NodeSelector:
  - node-type: infrastructure
  - workload-type: platform
- Afinidad: No configurada

### RBAC y Cuenta de Servicio
Configuración:
- RBAC: Habilitado
- PSP: Deshabilitado
- Cuenta de servicio: Creada con nombre "flagger"

<a name="despliegue"></a>
## Despliegue
Esta ves se desplegara con argocd 

Para desplegar Flagger:
```bash
kubectl apply -f argocd-flagger.yaml
```
<a name="verificacion"></a>
## Verificación
### Verificar pods de Flagger
```bash
kubectl get pods -n flagger
```

### Verificar servicios
```bash
kubectl get svc -n flagger
```

### Verificar configuración de Flagger
```bash
kubectl get canaries --all-namespaces
```

### Verificar recursos creados
```bash
kubectl get deployment,sa,clusterrole,clusterrolebinding -l app.kubernetes.io/name=flagger
```

 ```bash
kubectl get canaries --all-namespaces
kubectl describe canary [nombre-canary] -n [namespace]
 ```
- Verificacion funcionamiento con catalogue de robot-shop
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Flagger-helm/imagenes/flagger-1.png)

- Verificacion despligue con argocd
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Flagger-helm/imagenes/flagger-2.png)
