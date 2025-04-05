# Prometheus Stack - Configuración y Despliegue

Este repositorio contiene configuraciones para desplegar y gestionar Prometheus Stack en entornos de Kubernetes, con diferentes métodos de despliegue.

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:
```
├── argocd/                     # Despliegue usando ArgoCD
├── helm/                       # Despliegue con Helm
├── imagenes/                   # Recursos gráficos y capturas
├── terraform/                  # Despliegue con Terraform
```

### Método 1: Despliegue con ArgoCD
El directorio `argocd/` contiene configuraciones para desplegar Prometheus Stack utilizando ArgoCD como herramienta de despliegue continuo. Este método proporciona una gestión declarativa, automatizada y basada en GitOps para mantener la instalación de Prometheus Stack.

### Método 2: Despliegue con Helm
El directorio `helm/` contiene charts y valores de Helm para desplegar Prometheus Stack y sus componentes. Este método proporciona una forma estandarizada de gestionar las instalaciones y actualizaciones directamente con Helm.

### Método 3: Despliegue con Terraform
El directorio `terraform/` contiene la configuración necesaria para desplegar Prometheus Stack utilizando Terraform. Este método es ideal para equipos que ya utilizan Terraform para gestionar su infraestructura y prefieren un enfoque unificado.

### Recursos Gráficos
El directorio `imagenes/` contiene capturas de pantalla, diagramas y otros recursos visuales que ayudan a documentar la arquitectura y el funcionamiento de Prometheus Stack en el entorno.

## Cómo Empezar
1. Elige el método de despliegue que mejor se adapte a tus necesidades
2. Navega al directorio correspondiente
3. Sigue las instrucciones específicas para el despliegue en tu entorno
