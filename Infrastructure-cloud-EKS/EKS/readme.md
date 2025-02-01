# Indice

# Infraestructura de AWS EKS con Terraform para Robot-shop

Este repositorio contiene configuraciones de Terraform para desplegar un clúster de Amazon EKS (Elastic Kubernetes Service) con una infraestructura VPC de soporte y complementos esenciales.

## Requisitos Previos

- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- helm

## Descripción General

La infraestructura incluye:
- VPC con subredes públicas, privadas e internas en 2 zonas de disponibilidad
- Clúster EKS (versión 1.32) con grupos de nodos gestionados
- Complementos principales: CoreDNS, kube-proxy, VPC CNI y EKS Pod Identity Agent
- Integración con AWS EBS CSI Driver
- Soporte para aprovisionamiento de nodos con Karpenter
- Configuraciones de grupos de seguridad preparadas para Istio

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


