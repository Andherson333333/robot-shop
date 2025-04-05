# Implementación de Amazon EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Estructura de Archivos](#estructura)
* [Arquitectura](#arquitectura)
* [Componentes Principales](#componentes)
* [Configuración](#configuracion)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)
* [Siguientes Pasos](#siguientes)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa un clúster Amazon EKS (Elastic Kubernetes Service) con las mejores prácticas de AWS. El clúster está configurado con una estructura de red segura, grupos de nodos gestionados, y complementos esenciales para la operación de Kubernetes.

<a name="requisitos"></a>
## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- IAM permisos para crear/gestionar recursos EKS

<a name="estructura"></a>
## Estructura de Archivos

La implementación de EKS está organizada en los siguientes archivos:

### `data.tf`
Contiene las fuentes de datos necesarias para la implementación:
- AWS Availability Zones disponibles
- Token de autorización para ECR público
- Información de la cuenta AWS del llamador

### `local.tf`
Define las variables locales usadas en la configuración:
- Nombre del clúster
- Región AWS
- CIDR de la VPC
- Zonas de disponibilidad
- Etiquetas comunes

### `provider.tf`
Configura los providers de Terraform necesarios:
- AWS (con versión específica)
- Kubectl para gestionar recursos de Kubernetes
- Helm para instalar charts
- Kubernetes para configurar recursos en el clúster

### `vpc.tf`
Configura la red virtual (VPC) para el clúster:
- Subnets públicas, privadas e intra
- NAT Gateway
- Internet Gateway
- Tablas de enrutamiento
- Etiquetas necesarias para Kubernetes y Karpenter

### `eks.tf`
Configura el clúster EKS y sus componentes:
- Versión del clúster
- Grupos de seguridad
- Add-ons del clúster
- Grupo de nodos gestionado
- Configuración de cifrado
- IRSA (IAM Roles for Service Accounts)

<a name="arquitectura"></a>
## Arquitectura

![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-6.png)

El clúster está diseñado con un enfoque en la seguridad, escalabilidad y mantenibilidad:

- **Múltiples zonas de disponibilidad** para alta disponibilidad
- **Subnets privadas** para los nodos de trabajo
- **Subnets públicas** para recursos que requieren acceso directo a Internet
- **Subnets intra** para el plano de control de EKS
- **NAT Gateway** para permitir el acceso a Internet desde las subnets privadas
- **Grupos de seguridad** configurados para el tráfico entre componentes del cluster

<a name="componentes"></a>
## Componentes Principales

El clúster EKS incluye los siguientes componentes principales:

### VPC y Networking
- VPC dedicada con CIDR 10.0.0.0/16
- Subnets públicas para balanceadores de carga
- Subnets privadas para nodos de trabajo
- Subnets intra para comunicación del plano de control
- NAT Gateway para acceso a Internet desde subnets privadas
- DNS hostnames y soporte habilitados

### Clúster EKS
- Versión 1.32 con endpoint público
- Permisos de administrador para el creador del clúster
- IRSA (IAM Roles for Service Accounts) habilitado
- Cifrado de secrets con KMS

### Add-ons de EKS
- CoreDNS para resolución de DNS interna
- kube-proxy para enrutamiento de red
- Amazon VPC CNI para networking de pods
- EBS CSI Driver para almacenamiento persistente
- Pod Identity Agent para autenticación

### Grupo de Nodos Gestionado
- Nodos tipo Infrastructure con instancias t3.medium
- Configurados con taints para cargas de trabajo específicas
- Autoscaling configurado (min: 1, max: 10, desired: 1)
- Etiquetas para identificar tipos de nodos

### Reglas de Seguridad
- Configuradas específicamente para soportar Istio
- Permiten la comunicación entre el plano de control y los nodos
- Habilitan los puertos necesarios para Istio (15010, 15012, 15014, 15017)

<a name="despliegue"></a>
## Despliegue

Para desplegar el clúster EKS:

1. Inicializar Terraform:
   ```bash
   terraform init
   ```

2. Ver los cambios que se aplicarán:
   ```bash
   terraform plan
   ```

3. Aplicar la configuración:
   ```bash
   terraform apply
   ```

4. Configurar kubectl para conectarse al clúster:
   ```bash
   aws eks update-kubeconfig --name my-eks --region us-east-1
   ```

<a name="verificacion"></a>
## Verificación

Para verificar que el clúster EKS está funcionando correctamente:

```bash
# Verificar el estado del clúster
kubectl cluster-info

# Verificar los nodos
kubectl get nodes -o wide

# Verificar los pods del sistema
kubectl get pods -n kube-system

# Verificar los add-ons instalados
kubectl get pods -n kube-system -l k8s-app=kube-dns  # CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-proxy  # kube-proxy
kubectl get pods -n kube-system -l app=aws-node  # VPC CNI
kubectl get pods -n kube-system -l app=ebs-csi-controller  # EBS CSI Driver
```
- Eks AWS
![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-1.png)

- Internamente cluster
![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-2.png)

- VPC
![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-3.png)

- Add on
![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-4.png)

- Cluster 
![Arquitectura Amazon EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-5.png)


