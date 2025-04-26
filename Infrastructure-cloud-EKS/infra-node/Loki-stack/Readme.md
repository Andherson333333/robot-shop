> Spanish version of this README is available as ReadmeES.md

# Loki Stack - Configuration and Deployment
This repository contains configurations for deploying and managing Loki Stack in Kubernetes environments, with different deployment methods.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Deployment using ArgoCD
├── helm/                       # Deployment with Helm
```

### Method 1: Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Loki Stack using ArgoCD as a continuous deployment tool. This method provides a declarative, automated, and GitOps-based management to maintain the Loki Stack installation.

### Method 2: Deployment with Helm
The `helm/` directory contains Helm charts and values for deploying Loki Stack and its components. This method provides a standardized way to manage installations and updates directly with Helm.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory or use the Terraform file
3. Follow the specific instructions for deployment in your environment
