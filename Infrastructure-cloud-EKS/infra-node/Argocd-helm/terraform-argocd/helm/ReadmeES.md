# Robot Shop ArgoCD Configuracion

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura de Archivos](#estructura)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Acceso](#acceso)
* [Verificación](#verificacion)
* 
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
<a name="estructura"></a>
## Estructura de Archivos

```
.
├── argocd-helm.tf     # Contiene la configuración del proveedor Helm y el recurso para desplegar ArgoCD usando Helm
├── argocd-ingress.tf  # Define los recursos de Kubernetes para configurar el ingress interno y el ingress para webhooks
├── argocd-secret.yml  # Archivo YAML con la configuración del secreto para los webhooks de GitHub
└── readme.md          # Documentación del módulo
```
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
1. Asegúrese de tener el cluster EKS, EBS y loadbalancer nginx desplegado 
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
- Pod y service
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-1.png)
- Aplicacion con el ingress y dominio funcionando
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-2.png)
- Aplicaciones desplegadas con argocd
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Argocd-helm/imagenes/argocd-3.png)
