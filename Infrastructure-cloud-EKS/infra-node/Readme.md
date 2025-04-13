# Infra-Node: Herramientas de Observabilidad y Gestión

## Índice
1. [Descripción General](#descripción-general)
2. [Estructura del Directorio](#estructura-del-directorio)
3. [Métodos de Despliegue](#métodos-de-despliegue)
   - [Despliegue con GitOps (ArgoCD)](#despliegue-con-gitops-argocd)
   - [Despliegue manual con Helm](#despliegue-manual-con-helm)
4. [Componentes](#componentes)
   - [Prometheus-stack](#prometheus-stack)
   - [ArgoCD](#argocd)
   - [Istio](#istio)
   - [Jaeger](#jaeger)
   - [Kiali](#kiali)
   - [Loki-stack](#loki-stack)
   - [Metrics-server](#metrics-server)
   - [Flagger-helm](#flagger-helm)
   - [Kubecost](#Kubecost)
5. [Orden de Instalación Recomendado](#orden-de-instalación-recomendado)
6. [Notas Adicionales](#notas-adicionales)

## Descripción General
Este directorio contiene todas las herramientas de observabilidad, monitoreo y gestión necesarias para operar el clúster EKS. Estas herramientas proporcionan capacidades esenciales para la operación del clúster, incluyendo mallas de servicio, monitoreo, trazabilidad y despliegue continuo.

## Estructura del Directorio
```
.
├── Argocd-helm         # Configuración de ArgoCD para CI/CD basado en GitOps
├── Isitio-helm         # Malla de servicios para gestión de tráfico
├── Jagger              # Sistema de trazabilidad distribuida
├── Kiali               # Visualización de la malla de servicios
├── Loki-stack          # Agregación y análisis de logs
├── metrics-server      # Métricas básicas de Kubernetes
└── Prometheus-stack    # Monitoreo, métricas y alertas
└── Flagger-helm        # Despligue controlados
└── Kubecost            # Verificacion costos detallados
```

## Métodos de Despliegue
Este repositorio soporta 2 métodos de despliegue diferentes, lo que proporciona flexibilidad según las necesidades y preferencias del equipo:

### Despliegue con GitOps (ArgoCD)
Cada componente incluye un directorio `argocd` con la configuración necesaria para ser desplegado a través de ArgoCD:
1. Primero despliegue ArgoCD en el clúster
2. Las aplicaciones se desplegarán automáticamente según la configuración en cada directorio

### Despliegue manual con Helm
Cada componente que soporta Helm incluye un directorio `helm` con la configuración necesaria:
1. Modificar las versiones si es necesario

## Componentes
- `Prometheus-stack` Monitoreo, métricas y alertas
- `ArgoCD` Herramienta de entrega continua (CD) basada en GitOps
- `Istio` Malla de servicios para gestión de tráfico
- `Jaeger` Sistema de trazabilidad distribuida
- `Kiali` Visualización de la malla de servicios
- `Loki-stack` Agregación y análisis de logs
- `Metrics-server` Métricas básicas de Kubernetes
- `Flagger` Despligues controlados al cambiar de  version
- `Kubecost` Herramienta verificacion costo detallados

## Orden de Instalación Recomendado
Para un correcto funcionamiento, se recomienda instalar los componentes en el siguiente orden:
1. [Prometheus-stack](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack)
2. [ArgoCD](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm) (si se va a utilizar GitOps para el resto de despliegues)
3. [Istio](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm)
4. [Metrics-server](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/metrics-server)
5. [Loki-stack](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Loki-stack)
6. [Jaeger](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Jagger)
7. [Kiali](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Kiali)
8. [Flagger-helm](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/Flagger-helm)
9. [Kubecost](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-node/kubecost-helm)

## Notas Adicionales
- Cada componente incluye imágenes de documentación en su directorio `imagenes` que ayudan a entender su funcionamiento y configuración.
- Los directorios `argocd` están preparados para futuras implementaciones de GitOps.
- Algunos componentes ofrecen múltiples métodos de despliegue (Helm, Terraform, manifiestos directos) para adaptarse a diferentes flujos de trabajo.
- Cada directorio contiene su propio README con instrucciones específicas de configuración y despliegue.
