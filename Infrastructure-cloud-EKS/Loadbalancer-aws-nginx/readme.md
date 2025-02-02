 Nginx Ingress Controllers y AWS Load Balancer Controller para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)  
* [Componentes](#componentes)
* [AWS Load Balancer](#loadbalancer)
* [Nginx Ingress](#nginx)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa AWS Load Balancer Controller y dos controladores Nginx Ingress en el clúster EKS:
- Un controlador interno para tráfico dentro de la VPC
- Un controlador externo para tráfico público
Ambos utilizan Network Load Balancers (NLB) de AWS con diferentes configuraciones.

<a name="requisitos"></a>
## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm
- EKS desplegado

<a name="componentes"></a>
## Componentes
El despliegue configura:
- AWS Load Balancer Controller en namespace kube-system
- Dos controladores Nginx Ingress en namespaces dedicados
 - ingress-nginx-internal
 - ingress-nginx-external
- Network Load Balancers de AWS (interno y externo)
- Integración con AWS Certificate Manager
- Pod Identity para AWS Load Balancer Controller

<a name="loadbalancer"></a>
## AWS Load Balancer
### AWS Load Balancer Controller
Configuración:
- Nombre: aws-load-balancer-controller
- Namespace: kube-system
- Versión Chart: 1.11.0
- Pod Identity habilitado

<a name="nginx"></a>
## Nginx Ingress
### Externo
Configuración:
- Nombre: external
- Repositorio: kubernetes.github.io/ingress-nginx
- Versión: 4.12.0
- Namespace: ingress-nginx-external
- Clase: nginx-external
- HTTP: deshabilitado
- HTTPS: 443

### Interno
Configuración:
- Nombre: internal
- Repositorio: kubernetes.github.io/ingress-nginx
- Versión: 4.12.0
- Namespace: ingress-nginx-internal
- Clase: nginx-internal
- HTTP: deshabilitado
- HTTPS: 443

<a name="despliegue"></a>
## Despligue

1 - Una ves desplegado el EKS (https://github.com/Andherson333333/robot-shop/edit/master/Infrastructure-cloud-EKS/EKS/readme.md) , puede vernir a esta seccion a desplega el loadbalancer y implementar el ingress controller necesario para aplicar los ingress, cabe destacar que en esta configuracion ya esta los componenes pod identity instalado y listo para proceder con esta configuracion

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
<a name="verificacion"></a>
## Verificación

# Verificar AWS Load Balancer Controller
```
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

# Verificar los controladores Nginx
```
kubectl get pods -n ingress-nginx-internal
```
```
kubectl get pods -n ingress-nginx-external
```

# Verificar los servicios NLB
```
kubectl get svc -n ingress-nginx-internal
```
```
kubectl get svc -n ingress-nginx-external
```
# Verificar las clases de ingress
```
kubectl get ingressclass
```
