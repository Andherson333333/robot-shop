# Infra-Terraform: Infraestructura Base de AWS EKS

## Índice
1. [Descripción General](#descripción-general)
2. [Estructura del Directorio](#estructura-del-directorio)
3. [Componentes](#componentes)
   - [EKS](#eks)
   - [EBS](#ebs)
   - [Karpenter](#karpenter)
   - [Loadbalancer-aws-nginx](#loadbalancer-aws-nginx)
4. [Método de Despliegue](#método-de-despliegue)
5. [Orden de Despliegue Recomendado](#orden-de-despliegue-recomendado)
6. [Requisitos Previos](#requisitos-previos)
7. [Notas Adicionales](#notas-adicionales)

## Descripción General
Este directorio contiene toda la infraestructura base necesaria para desplegar un clúster EKS en AWS utilizando Terraform. Incluye la definición del clúster, almacenamiento, auto-escalado y balanceo de carga.

## Estructura del Directorio
```
.
├── EBS                      # Driver EBS CSI para almacenamiento persistente
├── EKS                      # Definición del clúster EKS y VPC
├── Karpenter                # Auto-escalado automático de nodos
└── Loadbalancer-aws-nginx   # Controlador AWS LoadBalancer y NGINX Ingress
```

## Componentes

### EKS
Configuración del clúster Elastic Kubernetes Service de AWS y la infraestructura de red asociada.

### EBS
Configuración del driver CSI (Container Storage Interface) de EBS para proporcionar almacenamiento persistente al clúster.

### Karpenter
Solución de auto-escalado de nodos para Kubernetes que mejora la eficiencia y la velocidad de escalado.

### Loadbalancer-aws-nginx
Configuración del AWS Load Balancer Controller y NGINX Ingress para la exposición de servicios.

## Método de Despliegue

Todo el despliegue de la infraestructura se realiza utilizando Terraform. Para cada componente, se sigue el siguiente procedimiento:

```bash
# Navegar al directorio del componente
cd [directorio-componente]

# Inicializar Terraform
terraform init

# Validar la configuración
terraform validate

# Ver el plan de cambios
terraform plan

# Aplicar los cambios
terraform apply
```

Los recursos se crean de manera declarativa y reproducible, permitiendo una gestión consistente de la infraestructura como código (IaC).

## Requisitos Previos
- AWS CLI configurado con credenciales válidas
- Terraform ≥ v1.0
- kubectl configurado
- Permisos IAM suficientes para crear recursos EKS, VPC, IAM Roles, etc.

## Orden de Despliegue Recomendado
Para un correcto funcionamiento, se recomienda desplegar los componentes en el siguiente orden:

1. [EKS](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/EKS) - Clúster base y VPC
2. [EBS](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/EBS) - Almacenamiento persistente
3. [Karpenter](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/Karpenter) - Auto-escalado
4. [Loadbalancer-aws-nginx](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx) - Balanceo de carga e ingress

## Notas Adicionales
- Cada componente incluye imágenes de documentación en su directorio `imagenes` que ayudan a entender su funcionamiento y configuración.
- Cada directorio contiene su propio README con instrucciones específicas de configuración y despliegue.
- Los valores predeterminados están configurados para un entorno de producción, pero pueden ser adaptados según sea necesario.
- Se recomienda revisar y ajustar las configuraciones de seguridad antes de desplegar en un entorno de producción.
