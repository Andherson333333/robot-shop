# Karpenter para EKS

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Arquitectura](#arquitectura)
* [Estructura de Archivos](#estructura)
* [Tipos de Nodos](#tipos-nodos)
* [Rol de Servicio para EC2 Spot](#rol-spot)
* [Despliegue](#despliegue)
* [Verificación](#verificacion)
* [Ejemplos de Uso](#ejemplos)

<a name="descripcion"></a>
## Descripción General
Este módulo implementa Karpenter, un autoscaler de nodos para Kubernetes que permite escalar el clúster de forma rápida y eficiente. Karpenter aprovisiona nodos en respuesta a la demanda de recursos de los pods pendientes, mejorando la eficiencia y reduciendo costos.

<a name="requisitos"></a>
## Requisitos Previos
- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- EKS desplegado
- AWS Load Balancer Controller (opcional, para exponer servicios)

<a name="componentes"></a>
## Componentes
- Namespace dedicado para Karpenter
- Controlador Karpenter usando Helm
- Pod Identity para permisos IAM seguros
- EC2NodeClass para configuración de instancias
- NodePools para diferentes tipos de cargas de trabajo
- Rol de servicio para instancias EC2 Spot

<a name="arquitectura"></a>
## Arquitectura

![Arquitectura Karpenter](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Karpenter/imagenes/karpenter-9.png)

Karpenter funciona detectando pods pendientes que no pueden ser programados debido a la falta de recursos, y aprovisiona automáticamente nuevos nodos que cumplen con los requisitos de estos pods.

<a name="estructura"></a>
## Estructura de Archivos

La implementación de Karpenter está organizada en los siguientes archivos:

### `karpenter-namespace.tf`

Define el namespace dedicado para Karpenter dentro del clúster Kubernetes. Todos los componentes de Karpenter se despliegan en este namespace para mantener una organización adecuada.

### `karpenter-controler.tf`

Configura el controlador de Karpenter utilizando el módulo Terraform oficial. Este archivo establece:
- La configuración básica de Karpenter
- La integración con Pod Identity para permisos IAM seguros
- La habilitación del manejador de terminación de instancias Spot
- Los permisos IAM adicionales necesarios para los nodos

### `karpenter-helm.tf`

Implementa el chart de Helm de Karpenter con la configuración específica para nuestro entorno:
- Configuración de la cuenta de servicio
- Configuración del nombre y endpoint del clúster
- Configuración de la cola de interrupciones para instancias Spot

### `karpenter-nodepool.tf`

Define el EC2NodeClass común para todos los NodePools, especificando:
- Familia AMI (Amazon Linux 2023)
- Configuración del rol de IAM
- Selectores de subred y grupos de seguridad basados en etiquetas
- Etiquetas adicionales para el descubrimiento

### `karpenter_infra_node_pool.tf`

Configura el NodePool para infraestructura, destinado a componentes críticos del sistema:
- Etiquetas para identificar nodos de infraestructura
- Taints para prevenir la programación de cargas de trabajo generales
- Restricción a tipos de instancia específicos
- Uso exclusivo de instancias on-demand
- Límites de recursos y políticas de consolidación

### `karpenter_app_node_pool.tf`

Configura el NodePool para aplicaciones, destinado a cargas de trabajo de negocio:
- Etiquetas para identificar nodos de aplicación
- Sin taints para permitir la programación de cualquier carga de trabajo
- Soporte para instancias Spot y on-demand
- Límites de recursos más amplios

### `spot-rol-karpenter.tf`

Este archivo es crucial para habilitar el uso de instancias Spot en el clúster. Realiza las siguientes acciones:
- Verifica si el rol de servicio `AWSServiceRoleForEC2Spot` existe
- Crea el rol vinculado al servicio si no existe
- Espera a que el rol se propague en AWS
- Referencia el rol para su uso en otras partes de la configuración

<a name="tipos-nodos"></a>
## Tipos de Nodos

La implementación define dos tipos principales de nodos que Karpenter puede aprovisionar:

### 1. Nodos de Infraestructura
Estos nodos están dedicados a cargas de trabajo críticas de la plataforma:

- **Propósito**: Ejecutar componentes esenciales como controladores, sistemas de monitoreo y servicios de plataforma
- **Etiquetas**: `node-type: infrastructure` y `workload-type: platform`
- **Taints**: `workload-type=infrastructure:PreferNoSchedule`
- **Tipo de Capacidad**: Exclusivamente instancias on-demand
- **Tipos de Instancia**: t3.medium, t3.large, t3.xlarge

### 2. Nodos de Aplicación
Estos nodos están diseñados para cargas de trabajo generales:

- **Propósito**: Ejecutar aplicaciones de negocio y microservicios
- **Etiquetas**: `node-type: application` y `workload-type: business`
- **Taints**: Ninguno
- **Tipo de Capacidad**: Mezcla de instancias on-demand y Spot
- **Tipos de Instancia**: t3.medium, t3.large

<a name="rol-spot"></a>
## Rol de Servicio para EC2 Spot

El archivo `spot-rol-karpenter.tf` es particularmente importante ya que configura el rol de servicio necesario para que AWS pueda gestionar instancias Spot en nombre del clúster EKS.

Este rol vinculado al servicio permite a AWS:
- Solicitar y gestionar instancias Spot en tu cuenta
- Manejar interrupciones de instancias Spot de manera adecuada
- Asegurar que tus cargas de trabajo pueden migrar antes de que se terminen las instancias Spot

El procedimiento utiliza el comando AWS CLI para verificar si el rol ya existe y lo crea si es necesario, evitando errores si ya está presente. Después de crear o verificar el rol, espera 10 segundos para asegurar que el rol se propague correctamente a través de los servicios de AWS.

<a name="despliegue"></a>
## Despliegue

1. Asegúrate de tener el EKS desplegado ([ver documentación de EKS](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/EKS/readme.md))

2. Para instalar Karpenter:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

<a name="verificacion"></a>
## Verificación

Para verificar que Karpenter esté funcionando correctamente:

```bash
# Verificar que los pods de Karpenter estén en ejecución
kubectl get pods -n karpenter

# Verificar que las NodeClass y NodePools se han creado correctamente
kubectl get ec2nodeclasses
kubectl get nodepools

# Verificar que el rol de servicio para Spot existe
aws iam get-role --role-name AWSServiceRoleForEC2Spot

# Verificar que Karpenter ha aprovisionado nuevos nodos
kubectl get nodes --watch
```

<a name="ejemplos"></a>
## Ejemplos de Uso

### Etiquetas para Nodos de Infraestructura
```yaml
nodeSelector:
  node-type: infrastructure
  workload-type: platform
```

### Etiquetas y Toleraciones para Nodos de Infraestructura
```yaml
nodeSelector:
  node-type: infrastructure
  workload-type: platform
tolerations:
- key: "workload-type"
  operator: "Equal"
  value: "infrastructure"
  effect: "PreferNoSchedule"
```

### Etiquetas para Nodos de Aplicación
```yaml
nodeSelector:
  node-type: application
```

