# Loki Stack - Configuración y Despliegue

Este repositorio contiene configuraciones para desplegar y gestionar Loki Stack en entornos de Kubernetes, con diferentes métodos de despliegue.

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:
```
├── argocd/                     # Despliegue usando ArgoCD
├── helm/                       # Despliegue con Helm

```

### Método 1: Despliegue con ArgoCD
El directorio `argocd/` contiene configuraciones para desplegar Loki Stack utilizando ArgoCD como herramienta de despliegue continuo. Este método proporciona una gestión declarativa, automatizada y basada en GitOps para mantener la instalación de Loki Stack.

### Método 2: Despliegue con Helm
El directorio `helm/` contiene charts y valores de Helm para desplegar Loki Stack y sus componentes. Este método proporciona una forma estandarizada de gestionar las instalaciones y actualizaciones directamente con Helm.


## Cómo Empezar
1. Elige el método de despliegue que mejor se adapte a tus necesidades
2. Navega al directorio correspondiente o utiliza el archivo Terraform
3. Sigue las instrucciones específicas para el despliegue en tu entorno
