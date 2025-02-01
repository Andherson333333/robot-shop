# Infraestructura de AWS EKS con Terraform para Robot-shop

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Estructura del Proyecto](#estructura)
* [Componentes Principales](#componentes)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene configuraciones de Terraform para desplegar un clúster de Amazon EKS (Elastic Kubernetes Service) con una infraestructura VPC de soporte y complementos esenciales para la aplicación robot-shop.

<a name="requisitos"></a>
## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm

<a name="estructura"></a>
## Estructura del Proyecto
La infraestructura incluye:
- VPC con subredes públicas, privadas e internas en 2 zonas de disponibilidad
- Clúster EKS (versión 1.32) con grupos de nodos gestionados
- Complementos principales: CoreDNS, kube-proxy, VPC CNI y EKS Pod Identity Agent
- Integración con AWS EBS CSI Driver
- Soporte para aprovisionamiento de nodos con Karpenter
- Configuraciones de grupos de seguridad preparadas para Istio

<a name="componentes"></a>
## Componentes Principales

### Configuración de VPC
- CIDR: 10.0.0.0/16
- Subredes públicas, privadas e internas
- NAT Gateway
- Soporte DNS habilitado

### Clúster EKS
- Versión de Kubernetes: 1.31
- Acceso público al endpoint habilitado
- IRSA (IAM Roles for Service Accounts) habilitado
- Configuración de grupo de nodos gestionados:
 - Tipo de instancia: t3.medium
 - Tamaño mínimo: 1
 - Tamaño máximo: 10
 - Tamaño deseado: 1

### Seguridad
Incluye configuraciones específicas para Istio:
- Puerto Webhook (15017)
- Puerto de Workload (15012)
- Puerto Discovery/XDS (15010)
- Puerto de Monitoreo (15014)

<a name="despliegue"></a>
## Despliegue
1. Una ves instalado los requisitos
```
terraform init
```
2. Verificar con terraform
```
terraform plan
```
3. Iniciar el despligue
```
terraform apply
```
4. Configuracion kubectl
```
aws eks update-kubeconfig --region us-east-1 --name my-eks
```

<a name="verificacion"></a>
## Verificacion 

1. Verificacion cluster con kubeclt
```
```


