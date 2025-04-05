# Robot Shop ArgoCD Configuracion

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Acceso](#acceso)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa ArgoCD en el clúster EKS, proporcionando una herramienta de Continuous Delivery (CD) con una interfaz web accesible a través de un ingress interno. Al ser interno solo se tiene acceso dentro de la vpc

<a name="requisitos"></a>
## Requisitos Previos
- EKS Cluster desplegado
- Nginx Ingress Controller interno configurado
- Dominio configurado (argocd.andherson33.click)
- Terraform >= 1.0
- kubectl
- helm

<a name="componentes"></a>
## Componentes
El despliegue configura:
- ArgoCD en namespace dedicado
- Ingress para acceso interno
- Ingress adicional para webhooks de GitHub
- Secreto para webhook de GitHub

<a name="configuracion"></a>
## Configuración

### ArgoCD Helm Chart
Configuración:
- Nombre: argocd
- Repositorio: argoproj.github.io/argo-helm
- Versión: 7.8.13
- Namespace: argocd

### Ingress
Configuración:
- Hostname: argocd.andherson33.click
- Clase: nginx-internal
- SSL Redirect: Deshabilitado
- Backend Protocol: HTTP

### Ingress Webhook
Configuración:
- Hostname: argocd.andherson33.click
- Path: /api/webhook
- Clase: nginx-external
- SSL Redirect: Deshabilitado
- Backend Protocol: HTTP

### GitHub Webhook
Configuración:
- Secret: "naruto"
- Endpoint: https://argocd.andherson33.click/api/webhook

<a name="despliegue"></a>
## Despliegue

```
helm install argocd argocd-helm/ --namespace argocd -f argocd-helm/values.yaml --create-namespace
```

<a name="acceso"></a>
## Acceso

ArgoCD estará disponible en:

URL: https://argocd.andherson33.click

Para obtener la contraseña inicial del admin:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
<a name="verificacion"></a>
## Verificación

### Verificar pods de ArgoCD
```
kubectl get pods -n argocd
```
### Verificar el ingress
```
kubectl get ingress -n argocd
```
### Verificar los servicios
```
kubectl get svc -n argocd
```
### Verificar los secretos
```
kubectl get secrets -n argocd
```
