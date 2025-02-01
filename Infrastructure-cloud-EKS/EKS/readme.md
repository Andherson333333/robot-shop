# Indice

# Infraestructura de AWS EKS con Terraform para Robot-shop

Este repositorio contiene configuraciones de Terraform para desplegar un clúster de Amazon EKS (Elastic Kubernetes Service) con una infraestructura VPC de soporte y complementos esenciales.

## Requisitos Previos

- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm

## Estructura del Proyecto

El proyecto está organizado en varias secciones dentro del mismo archivo (o puede dividirse en múltiples archivos según tu preferencia):

- **Variables locales**: Definición de parámetros como el nombre del clúster, región, CIDR para la VPC, zonas de disponibilidad y etiquetas.
- **Data Sources**: Obtención de información sobre zonas de disponibilidad, token de autorización para ECR Public y la identidad del llamador actual.
- **Providers**: Configuración de los proveedores de Terraform:
  - **aws** (con un alias para la región de Virginia).
  - **kubernetes**, **helm** y **kubectl** (configurados para comunicarse con el clúster EKS utilizando el comando `aws eks get-token`).
- **Módulo VPC**: Uso del módulo [terraform-aws-modules/vpc/aws](https://github.com/terraform-aws-modules/terraform-aws-vpc) para la creación de la VPC, subredes y NAT Gateway.
- **Módulo EKS**: Uso del módulo [terraform-aws-modules/eks/aws](https://github.com/terraform-aws-modules/terraform-aws-eks) para la creación y configuración del clúster EKS, incluyendo:
  - Addons del clúster.
  - Configuración de subredes para el plano de control y nodos.
  - Reglas de seguridad adicionales para la integración con Istio.
  - Configuración de grupos de nodos gestionados.

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





## Despligue

## Verificacion


