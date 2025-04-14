# Robot Shop Infrastructure on AWS EKS

## Índice

1. [Estructura del Repositorio](#estructura-del-repositorio)
2. [Componentes](#componentes)
   - [infra-terraform](#1-infra-terraform)
   - [infra-node](#2-infra-node)
   - [infra-aplicacion](#3-infra-aplicacion)
3. [Cómo Empezar](#cómo-empezar)
   - [Prerrequisitos](#prerrequisitos)
   - [Instalación de requisitos](#instalación-de-requisitos)
   - [Orden de despliegue](#orden-de-despliegue)
4. [Mantenimiento](#mantenimiento)
5. [Documentación Adicional](#documentación-adicional)

Este repositorio contiene toda la infraestructura necesaria para desplegar y gestionar la aplicación Robot Shop en Amazon EKS (Elastic Kubernetes Service). La infraestructura está dividida en tres componentes principales para facilitar su gestión y escalabilidad.

## Estructura del Repositorio

```
.
├── infra-aplicacion     # Aplicaciones de negocio
├── infra-node           # Herramientas de observabilidad y gestión
└── infra-terraform      # Infraestructura base de AWS EKS
```

## Componentes

### 1. infra-terraform

Este directorio contiene todos los archivos Terraform necesarios para provisionar y configurar el clúster EKS en AWS. Incluye:

- Definición del clúster EKS
- Configuración de VPC y subredes
- Grupos de seguridad
- Roles IAM y políticas
- Nodos de trabajo para el clúster

### 2. infra-node

Este directorio contiene la configuración para las herramientas de administración, observabilidad y gestión del tráfico del clúster. Incluye:

- **ArgoCD**: Herramienta de entrega continua (CD) basada en GitOps
- **Prometheus**: Monitoreo y alertas
- **Jaeger**: Trazabilidad distribuida
- **Kiali**: Observabilidad de malla de servicios
- **Istio**: Malla de servicios
- **Loki**: Agregación de logs
- **Flagger**: Despliegues canary automatizados
- **kubecost**: Costos detallados por pod

### 3. infra-aplicacion

Este directorio contiene las definiciones y configuraciones de las aplicaciones de negocio que se ejecutan en el clúster. Incluye:

- Manifiestos Kubernetes para aplicaciones Robot Shop
- Configuraciones de despliegue
- Definiciones de servicios
- Políticas de Istio
- Configuraciones específicas de aplicaciones

## Cómo Empezar

### Prerrequisitos

- AWS CLI configurado
- Terraform instalado
- kubectl instalado
- Acceso a AWS con permisos suficientes

### Instalación de requisitos

Para instalar todos los requisitos necesarios, ejecute el script de instalación:

```bash
# Dar permisos de ejecución al script
chmod +x install.sh

# Ejecutar el script
./install.sh
```

El script `install.sh` instalará automáticamente todas las herramientas y dependencias necesarias para trabajar con esta infraestructura.

### Orden de despliegue

Para un despliegue correcto, siga este orden:

1. infra-terraform
2. infra-node
3. infra-aplicacion

Cada directorio contiene instrucciones específicas sobre cómo realizar el despliegue.

## Mantenimiento

Para actualizar o modificar cualquier componente de la infraestructura, navegue al directorio correspondiente y siga las instrucciones específicas para ese componente.

## Documentación Adicional

Para obtener más información sobre cada componente, consulte los README específicos dentro de cada directorio.


