# Jaeger - Configuración y Despliegue

Este repositorio contiene configuraciones para desplegar y gestionar Jaeger en entornos de Kubernetes, con dos métodos diferentes de despliegue.

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:
```
├── argocd/                     # Despliegue usando ArgoCD
├── imagenes/                   # Recursos gráficos y capturas
├── manifiesto/                 # Despliegue usando manifiestos Kubernetes
```

### Método 1: Despliegue con Manifiestos Kubernetes
El directorio `manifiesto/` contiene los archivos YAML de Kubernetes necesarios para desplegar Jaeger directamente mediante kubectl. Este método es adecuado para entornos donde se prefiere un control directo sobre la instalación o donde no se cuenta con ArgoCD.

### Método 2: Despliegue con ArgoCD
El directorio `argocd/` contiene configuraciones para desplegar Jaeger utilizando ArgoCD como herramienta de despliegue continuo. Este método proporciona una gestión declarativa, automatizada y basada en GitOps para mantener la instalación de Jaeger.

### Recursos Gráficos
El directorio `imagenes/` contiene capturas de pantalla, diagramas y otros recursos visuales que ayudan a documentar la arquitectura y el funcionamiento de Jaeger en el entorno.

## Cómo Empezar
1. Elige el método de despliegue que mejor se adapte a tus necesidades
2. Navega al directorio correspondiente
3. Sigue las instrucciones específicas para el despliegue en tu entorno
