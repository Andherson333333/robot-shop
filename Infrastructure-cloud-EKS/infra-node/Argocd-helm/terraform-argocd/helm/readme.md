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
- StorageClass gp3-default disponible
- Dominio configurado (argocd.andherson33.click)
- Terraform >= 1.0
- kubectl
- helm

<a name="componentes"></a>
## Componentes
El despliegue configura:
- ArgoCD en namespace dedicado
- Redis con persistencia
- Ingress para acceso interno
- Ingress adicional para webhooks de GitHub
- Secreto para webhook de GitHub

<a name="configuracion"></a>
## Configuración

### ArgoCD Helm Chart
Configuración:
- Nombre: argocd
- Repositorio: argoproj.github.io/argo-helm
- Versión: 7.7.13
- Namespace: argocd

### Redis
Configuración:
- Persistencia: Habilitada
- StorageClass: gp3-default

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
1. Asegúrese de tener el cluster EKS, EBS y loadbalancer nginx desplegado 

   - https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/EKS
   - https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/EBS
   - https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/Loadbalancer-aws-nginx

2- Para instalar el nuevo modulo agregado
```
terraform init
```
3. Verificar con terraform
```
terraform plan
```
4. Iniciar el despligue
```
terraform apply
```
5. Aplicar el ingress para acceso GUI
```
kubectl appy -f argocd-ingress.yml
```
6. Aplicar el ingress para aplicar webhook de forma externa
```
kubectl appy -f argocd-ingress-webhoock.yml
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
