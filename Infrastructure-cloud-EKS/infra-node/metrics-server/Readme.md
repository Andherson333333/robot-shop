> Spanish version of this README is available as ReadmeES.md

# Metrics Server - Configuration and Deployment
This repository contains configurations for deploying and managing Metrics Server in Kubernetes environments, with different deployment methods.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Deployment using ArgoCD
├── helm/                       # Deployment with Helm
├── imagenes/                   # Graphic resources and screenshots
```

### Method 1: Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Metrics Server using ArgoCD as a continuous deployment tool. This method provides a declarative, automated, and GitOps-based management to maintain the Metrics Server installation.

### Method 2: Deployment with Helm
The `helm/` directory contains Helm charts and values for deploying Metrics Server and its components. This method provides a standardized way to manage installations and updates directly with Helm.

### Graphic Resources
The `imagenes/` directory contains screenshots, diagrams, and other visual resources that help document the architecture and operation of Metrics Server in the environment.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the specific instructions for deployment in your environment
