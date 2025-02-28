# Configuración de Karpenter para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)
* [Configuración Detallada](#configuracion)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa Karpenter en el clúster EKS. Karpenter es un autoscaler de nodos que permite escalar de manera eficiente los nodos del clúster basándose en las necesidades de los pods.

<a name="requisitos"></a>
## Requisitos Previos
- EKS Cluster desplegado
- Terraform >= 1.0
- AWS CLI configurado
- kubectl
- helm

<a name="componentes"></a>
## Componentes
El despliegue incluye:
- Namespace dedicado para Karpenter
- Módulo Karpenter con Pod Identity habilitado
- Chart de Helm de Karpenter
- NodeClass para AWS EC2
- NodePool con configuración personalizada

<a name="despliegue"></a>
## Despliegue
1. Asegúrese de tener el cluster EKS desplegado (https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/EKS) ya las configuraciones pertenentes y necesarias como los tag en el cluster esta configurados 

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
## Verificacion


<a name="configuracion"></a>
## Configuración Detallada

### NodeClass
La configuración principal para las instancias EC2 incluye:
- AMI Family: AL2023
- Subredes: Seleccionadas mediante tags
- Grupos de seguridad: Seleccionados mediante tags

### NodePool
Las especificaciones para el grupo de nodos son:
- Tipos de instancias soportadas:
 - t3.small
 - t3.medium
 - t3.large
- Arquitectura: amd64
- Tipo de capacidad: on-demand
- Límites de CPU: 100
- Política de consolidación: WhenEmpty
- Tiempo de consolidación: 30 segundos

### Políticas IAM
Las políticas IAM configuradas incluyen:
- SSM: AmazonSSMManagedInstanceCore

