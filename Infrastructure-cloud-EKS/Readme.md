> Spanish version of this README is available as ReadmeES.md

# Robot Shop Infrastructure on AWS EKS

## Table of Contents
1. [Repository Structure](#repository-structure)
2. [Components](#components)
   - [infra-terraform](#1-infra-terraform)
   - [infra-node](#2-infra-node)
   - [infra-application](#3-infra-application)
3. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Requirements Installation](#requirements-installation)
   - [Deployment Order](#deployment-order)
4. [Maintenance](#maintenance)
5. [Additional Documentation](#additional-documentation)

This repository contains all the necessary infrastructure to deploy and manage the Robot Shop application on Amazon EKS (Elastic Kubernetes Service). The infrastructure is divided into three main components to facilitate its management and scalability.

## Repository Structure
```
.
├── infra-aplicacion     # Business applications
├── infra-node           # Observability and management tools
└── infra-terraform      # AWS EKS base infrastructure
```

## Components

### 1. infra-terraform
This directory contains all the Terraform files needed to provision and configure the EKS cluster in AWS. It includes:
- EKS cluster definition
- VPC and subnet configuration
- Security groups
- IAM roles and policies
- Worker nodes for the cluster

### 2. infra-node
This directory contains the configuration for the cluster's administration, observability, and traffic management tools. It includes:
- **ArgoCD**: GitOps-based continuous delivery (CD) tool
- **Prometheus**: Monitoring and alerts
- **Jaeger**: Distributed tracing
- **Kiali**: Service mesh observability
- **Istio**: Service mesh
- **Loki**: Log aggregation
- **Flagger**: Automated canary deployments
- **kubecost**: Detailed pod-level cost analysis

### 3. infra-application
This directory contains the definitions and configurations for the business applications running on the cluster. It includes:
- Kubernetes manifests for Robot Shop applications
- Deployment configurations
- Service definitions
- Istio policies
- Application-specific configurations

## Getting Started

### Prerequisites
- AWS CLI configured
- Terraform installed
- kubectl installed
- AWS access with sufficient permissions

### Requirements Installation
To install all the necessary requirements, run the installation script:
```bash
# Give execution permissions to the script
chmod +x install.sh
# Run the script
./install.sh
```

The `install.sh` script will automatically install all the tools and dependencies needed to work with this infrastructure.

### Deployment Order
For a correct deployment, follow this order:
1. infra-terraform
2. infra-node
3. infra-application

Each directory contains specific instructions on how to perform the deployment.

## Maintenance
To update or modify any component of the infrastructure, navigate to the corresponding directory and follow the specific instructions for that component.

## Additional Documentation
For more information about each component, see the specific README files within each directory.
