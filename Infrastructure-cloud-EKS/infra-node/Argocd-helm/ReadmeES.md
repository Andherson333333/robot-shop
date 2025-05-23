# ArgoCD - Métodos de despliegue

Este repositorio contiene configuraciones para desplegar ArgoCD con dos métodos diferentes:

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:
```
├── helm/                   # Despliegue con helm
├── terraform-argocd/helm/  # Despliegue con terraform
```

### Método 1: Despliegue directo con Helm
El directorio `helm/` contiene configuraciones para desplegar aplicaciones usando charts de Helm directamente. Este método es adecuado para equipos familiarizados con Helm y que prefieren un enfoque más directo para la gestión de despliegues. Ofrece mayor flexibilidad y control manual sobre los despliegues.

### Método 2: Despliegue mediante Terraform
El directorio `terraform-argocd/helm/` contiene configuraciones para desplegar aplicaciones usando Terraform como orquestador de la infraestructura, que a su vez configura ArgoCD para gestionar los charts de Helm. 


## Cómo Empezar
1. Elige el método de despliegue que mejor se adapte a tus necesidades
2. Navega al directorio correspondiente
3. Sigue las instrucciones en el README específico del método
