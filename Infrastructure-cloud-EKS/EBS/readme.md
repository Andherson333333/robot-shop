# Configuración de AWS EBS CSI Driver para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Arquitectura](#arquitectura)
* [Configuración de Implementación](#configuracion)
* [Características Clave](#caracteristicas)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa el AWS EBS CSI Driver en el clúster EKS utilizando el sistema de Pod Identity de AWS. Permite el aprovisionamiento dinámico de volúmenes EBS para los Pods del clúster.

<a name="requisitos"></a>
## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm
- EKS desplegado

<a name="componentes"></a>
## Componentes
- Implementación del driver EBS CSI usando complementos (add-ons) de EKS
- Configurado con Pod Identity para permisos IAM seguros
- StorageClass gp3 predeterminada creada para aprovisionamiento dinámico
- Volúmenes cifrados por defecto usando AWS KMS
- Modo de vinculación WaitForFirstConsumer para mejorar la programación

<a name="arquitectura"></a>
## Arquitectura
![Arquitectura AWS EBS CSI Driver](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/EBS/imagenes/ebs-1.png)

El driver EBS CSI consta de:
`Pod Controlador:` Se ejecuta en el namespace kube-system y maneja las operaciones de aprovisionamiento de volúmenes
`DaemonSet de Nodo:` Se ejecuta en cada nodo para manejar la conexión/desconexión de volúmenes

El driver utiliza AWS Pod Identity para la gestión segura de credenciales sin necesidad de roles IAM para cuentas de servicio.

<a name="configuracion"></a>
## Configuración de Implementación

### Complemento del Driver AWS EBS CSI
El driver EBS CSI se implementa como un complemento de EKS con Pod Identity:
```hcl
cluster_addons = {
….
  aws-ebs-csi-driver     = {service_account_role_arn = module.eks-pod-identity.iam_role_arn}
}
```

### Configuración de Pod Identity
Pod Identity se utiliza para otorgar al driver EBS CSI permisos para gestionar volúmenes EBS con el módulo de Terraform:
```hcl
module "eks-pod-identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.9.0"
  
```

### StorageClass Predeterminada
Se crea una StorageClass predeterminada para habilitar el aprovisionamiento dinámico de volúmenes EBS:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: gp3-default
provisioner: ebs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
parameters:
  type: gp3
  fsType: ext4
  encrypted: "true"
  kmsKeyId: alias/aws/ebs
```

<a name="caracteristicas"></a>
## Características Clave

### Configuración de StorageClass Predeterminada
La StorageClass `gp3-default` proporciona las siguientes características:
- **Tipo de Volumen**: gp3 (SSD de propósito general de última generación)
- **Sistema de Archivos**: ext4
- **Cifrado**: Habilitado por defecto
- **Clave KMS**: Utiliza la clave KMS de EBS gestionada por AWS
- **Expansión**: Los volúmenes se pueden expandir sin desconectar
- **Política de Eliminación**: Los volúmenes se eliminan cuando se eliminan los PVCs
- **Modo de Vinculación**: WaitForFirstConsumer (mejora la programación de pods)

<a name="despliegue"></a>
## Despliegue
1. Una vez desplegado el EKS ([ver documentación de EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/EKS/readme.md)), puede venir a esta sección para desplegar el almacenamiento tipo EBS. Cabe destacar que en esta configuración ya están los componentes pod identity instalados y listos para proceder.

2. Para instalar el nuevo módulo agregado:
   ```bash
   terraform init
   ```

3. Verificar con terraform:
   ```bash
   terraform plan
   ```

4. Iniciar el despliegue:
   ```bash
   terraform apply
   ```

<a name="verificacion"></a>
## Verificación

Para verificar que el driver EBS CSI esté funcionando correctamente:

```
# Verificar el add-on de EBS CSI
kubectl get pods -n kube-system -l app=ebs-csi-controller

# Verificar la StorageClass
kubectl get sc
```
