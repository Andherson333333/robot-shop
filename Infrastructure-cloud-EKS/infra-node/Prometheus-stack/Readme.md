> Spanish version of this README is available as ReadmeES.md

# Prometheus Stack - Configuration and Deployment
This repository contains configurations for deploying and managing Prometheus Stack in Kubernetes environments, with different deployment methods.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Deployment using ArgoCD
├── helm/                       # Deployment with Helm
├── imagenes/                   # Graphic resources and screenshots
├── terraform/                  # Deployment with Terraform
```

### Method 1: Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Prometheus Stack using ArgoCD as a continuous deployment tool. This method provides a declarative, automated, and GitOps-based management to maintain the Prometheus Stack installation.

### Method 2: Deployment with Helm
The `helm/` directory contains Helm charts and values for deploying Prometheus Stack and its components. This method provides a standardized way to manage installations and updates directly with Helm.

### Method 3: Deployment with Terraform
The `terraform/` directory contains the necessary configuration to deploy Prometheus Stack using Terraform. This method is ideal for teams that already use Terraform to manage their infrastructure and prefer a unified approach.

### Graphic Resources
The `imagenes/` directory contains screenshots, diagrams, and other visual resources that help document the architecture and operation of Prometheus Stack in the environment.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the specific instructions for deployment in your environment
