# Kubecost Helm Configuración

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura de Archivos](#estructura)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Acceso](#acceso)
* [Verificación](#verificacion)
  
<a name="descripcion"></a>
## Descripción General
Este módulo implementa Kubecost en el clúster de Kubernetes utilizando Helm, proporcionando una herramienta de análisis y visibilidad de costos para monitorear y optimizar los gastos relacionados con la infraestructura de Kubernetes.

<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes en funcionamiento
- Nginx Ingress Controller configurado
- Dominio configurado (kubecost.andherson33.click)
- Helm v3 instalado
- kubectl configurado para acceder al clúster
- Prometheus instalado

<a name="componentes"></a>
## Componentes
El despliegue configura:
- Kubecost Cost Analyzer en un namespace dedicado
- Integración con Prometheus existente
- Frontend de Kubecost
- Grafana integrado
- Ingress para acceso externo
- Configuración de recursos optimizada

<a name="estructura"></a>
## Estructura de Archivos
```
.
├── templates/
│   └── ingress.yaml   # Plantilla para configurar el Ingress de Kubecost
├── Chart.yaml         # Metadatos del chart de Helm, incluye nombre, versión y dependencias
├── readme.md          # Documentación del módulo
└── values.yaml        # Valores configurables para personalizar la instalación
```

<a name="configuracion"></a>
## Configuración
### Kubecost Helm Chart
Configuración:
- Nombre: kubecost
- Versión Chart: 0.1.0
- Versión App: 2.7.0
- Dependencia: cost-analyzer 2.7.0
- Repositorio: https://kubecost.github.io/cost-analyzer/

### Integración con Prometheus
Configuración:
- Prometheus habilitado: false (usa una instancia existente)
- FQDN: http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090
- Grafana habilitado: true

### Recursos
Configuración:
- Kubecost Model Requests:
  - CPU: 200m
  - Memoria: 512Mi
- Kubecost Model Limits:
  - CPU: 800m
  - Memoria: 1Gi
- Readiness Probe: 120s initialDelay
- Liveness Probe: 120s initialDelay

### Ingress
Configuración:
- Hostname: kubecost.andherson33.click
- Clase: nginx-external
- SSL Redirect: Deshabilitado
- Backend Protocol: HTTP
- Proxy Body Size: 0 (ilimitado)
- Path: /
- Service: kubecost-cost-analyzer
- Puerto: 9090

### Tolerancias y Selectores de Nodos
Configuración:
- Tolerancias:
  - Key: workload-type
  - Value: infrastructure
  - Effect: PreferNoSchedule
- NodeSelector:
  - node-type: infrastructure
  - workload-type: platform

<a name="despliegue"></a>
## Despliegue
Actualizar el chart para sus dependencias:
```bash
helm dependency update
```

Desde afuera puedes usar un solo comando para desplegar y crear el namespace:
```bash
helm install kubecost . --namespace kubecost --create-namespace
```

Para actualizar una instalación existente:
```bash
helm upgrade kubecost . --namespace kubecost
```

<a name="acceso"></a>
## Acceso
Kubecost estará disponible en:
URL: https://kubecost.andherson33.click

Alternativamente, puedes usar port-forwarding para acceso local:
```bash
kubectl port-forward svc/kubecost-cost-analyzer 9090:9090 -n kubecost
```

URL local: http://localhost:9090

<a name="verificacion"></a>
## Verificación
### Verificar pods de Kubecost
```bash
kubectl get pods -n kubecost
```

### Verificar el ingress
```bash
kubectl get ingress -n kubecost
```

### Verificar los servicios
```bash
kubectl get svc -n kubecost
```

### Verificar los deployments
```bash
kubectl get deployments -n kubecost
```

### Verificar la integración con Prometheus
```bash
kubectl exec -it deployment/kubecost-cost-analyzer -n kubecost -- curl -s http://prometheus-stack-kube-prom-prometheus.monitoring.svc:9090/-/healthy
```

### Dashboard de Kubecost

- Verificación de funcionamiento via ingress
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/kubecost-helm/imagenes/kube-cost-1.png)


- Verificación funcionamiento
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/kubecost-helm/imagenes/kube-cost-2.png)
