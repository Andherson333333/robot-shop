# Flagger - Configuración y Despliegue

Este repositorio contiene configuraciones para desplegar Flagger en diferentes entornos, 

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:

```
├── argocd/                     # Configuraciones de despliegue de Istio usando ArgoCD
├── helm/                       # Despliegue con Helm
├── imagenes/                   # Recursos gráficos y capturas
├── Canary/                     # Manifiesto Canary
```

### Despliegue de flagger con ArgoCD
El directorio `argocd/` contiene configuraciones para desplegar Istio utilizando ArgoCD como herramienta de despliegue continuo en un clúster EKS (Elastic Kubernetes Service) de AWS. Estas configuraciones permiten la gestión declarativa y automatizada de Istio.

### Despliegue con Helm
El directorio `helm/` contiene charts y valores de Helm para desplegar Istio y sus componentes. Este método proporciona una forma estandarizada de gestionar las instalaciones y actualizaciones de Istio.

### Recursos Gráficos
El directorio `imagenes/` contiene capturas de pantalla, diagramas y otros recursos visuales que ayudan a documentar la arquitectura y el funcionamiento de Istio en el entorno.

### Despligue Canary

El directorio `Canary/` contiene manifiesto de canay para aplicarlos 

## Cómo Empezar
1. Elige el método de despliegue que mejor se adapte a tus necesidades
2. Navega al directorio correspondiente
3. Sigue las instrucciones específicas para el despliegue en tu entorno
