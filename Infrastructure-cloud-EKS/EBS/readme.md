# Configuración de AWS EBS CSI Driver para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Componentes](#componentes)
* [Configuración](#configuracion)
* [StorageClass](#storageclass)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa el AWS EBS CSI Driver en el clúster EKS utilizando el sistema de Pod Identity de AWS. Permite el aprovisionamiento dinámico de volúmenes EBS para los Pods del clúster.

## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm
- EKS desplegado

<a name="componentes"></a>
## Componentes
El despliegue incluye:
- Módulo EKS Pod Identity para AWS EBS CSI Driver
- StorageClass por defecto para volúmenes GP3
- Configuración de roles y políticas IAM necesarias

## Despligue

1 - Una ves desplegado el EKS (https://github.com/Andherson333333/robot-shop/edit/master/Infrastructure-cloud-EKS/EKS/readme.md) , puede vernir a esta seccion a desplega el almacenamiento tipo EBS , cabe destacar que en esta configuracion ya esta los componenes pod identity instalado y listo para proceder con esta configuracion

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





