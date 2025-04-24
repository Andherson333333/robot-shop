> Spanish version of this README is available as ReadmeES.md

# ArgoCD - Deployment Methods
This repository contains configurations for deploying ArgoCD using two different methods:

## Repository Structure
The repository is organized as follows:
```
├── helm/                   # Deployment with helm
├── terraform-argocd/helm/  # Deployment with terraform
```

### Method 1: Direct Deployment with Helm
The `helm/` directory contains configurations for deploying applications using Helm charts directly. This method is suitable for teams familiar with Helm who prefer a more direct approach to deployment management. It offers greater flexibility and manual control over deployments.

### Method 2: Deployment using Terraform
The `terraform-argocd/helm/` directory contains configurations for deploying applications using Terraform as the infrastructure orchestrator, which in turn configures ArgoCD to manage Helm charts.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the instructions in the method-specific README
