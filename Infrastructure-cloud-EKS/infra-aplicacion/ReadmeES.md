# Infra-Aplicacion: Aplicaciones de Negocio

## Índice
1. [Descripción General](#descripción-general)
3. [Métodos de Despliegue](#métodos-de-despliegue)
   - [Despliegue con Kubernetes Manifiestos](#despliegue-con-kubernetes-manifiestos)
   - [Despliegue con GitOps (ArgoCD)](#despliegue-con-gitops-argocd)
4. [Notas Adicionales](#notas-adicionales)

## Descripción General
Este directorio contiene las definiciones y configuraciones de las aplicaciones de negocio que se ejecutan en el clúster EKS. Actualmente, contiene la aplicación Robot Shop, una tienda de demostración basada en microservicios.

## Métodos de Despliegue

Hay 2 formas de despligue :

### Despliegue con Kubernetes Manifiestos
Todos los componentes de la aplicación se pueden desplegar directamente usando los manifiestos Kubernetes proporcionados:

### Despliegue con GitOps (ArgoCD)
La aplicación también está configurada para ser desplegada a través de ArgoCD. Para utilizar este método:

1. Asegúrese de que ArgoCD esté instalado en el clúster
2. Sincronice la aplicación para desplegar todos los recursos

## Notas Adicionales
- Cada directorio contiene su propio README con instrucciones específicas de configuración y despliegue.
- Consulte la documentación interna para más detalles sobre la aplicación y su arquitectura.
