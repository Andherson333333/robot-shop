# Istio Service Mesh

## Índice de contenidos
* [Descripción General](#descripcion)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Verificación](#verificacion)


<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración para desplegar Istio Service Mesh en un clúster Kubernetes. Istio es una plataforma de malla de servicios que proporciona capacidades de gestión de tráfico, seguridad, observabilidad y políticas para aplicaciones modernas basadas en microservicios.

<a name="estructura"></a>
## Estructura del Repositorio
```
.
├── Chart.yaml          # Definición de dependencias de Istio
├── templates/          # Recursos personalizados adicionales
├── values.yaml         # Configuración personalizada de Istio
└── README.md           # Esta documentación
```

### Chart.yaml
Este archivo define las dependencias del chart de Istio:

```yaml
apiVersion: v2
name: istio
description: Istio Installation Bundle
version: 1.0.0
dependencies:
  - name: base
    version: 1.24.2
    repository: https://istio-release.storage.googleapis.com/charts
  - name: istiod
    version: 1.24.2
    repository: https://istio-release.storage.googleapis.com/charts
```

- **Base (v1.24.2)**: Componentes fundamentales e instalación de CRDs
- **Istiod (v1.24.2)**: Plano de control de Istio


![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-1.png)



<a name="configuracion"></a>
## Configuración

### values.yaml
El archivo de valores contiene la configuración específica para los componentes de Istio:

```yaml
global:
  nodeSelector:
    node-type: infrastructure
    workload-type: platform
  # Configuración de tolerancias para todos los componentes 
  tolerations:
  - key: "workload-type"
    value: "infrastructure"
    effect: "NoSchedule"

base:
  enabled: true

istiod:
  meshConfig:
    enableTracing: true
    extensionProviders:
      - name: jaeger
        opentelemetry:
          port: 4317
          service: jaeger-collector.istio-system.svc.cluster.local
```

**Características clave:**
- Habilita los componentes base de Istio
- Activa la trazabilidad mediante Jaeger usando OpenTelemetry
- Se despliega en nodos de infraestructura (`node-type: infrastructure`)

<a name="instalacion"></a>
## Instalación

Para instalar Istio, ejecute:

```bash
# Crear el namespace para Istio
kubectl create namespace istio-system

# Actualizar las dependencias de Helm
helm dependency update

# Instalar el chart
helm install istio . -n istio-system
```

<a name="verificacion"></a>
## Verificación

Para verificar que Istio se ha instalado correctamente:

```bash
# Verificar que los pods de Istio están ejecutándose
kubectl get pods -n istio-system

# Comprobar la versión de Istio
kubectl get pods -l app=istiod -n istio-system -o jsonpath='{.items[0].metadata.labels.istio\.io/rev}'

# Verificar que los pods se están ejecutando en los nodos de infraestructura
kubectl get pods -n istio-system -o wide
```
- Pod y servicio Istio
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-3.png)

- Aplicando Istio a la aplicacion
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/robot-shop-eks-2.png)




