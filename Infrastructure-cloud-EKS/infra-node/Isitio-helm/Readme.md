> Spanish version of this README is available as ReadmeES.md

# Istio - Configuration and Deployment
This repository contains configurations for deploying Istio in different environments.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Istio deployment configurations using ArgoCD
├── helm/                       # Deployment with Helm
├── imagenes/                   # Graphic resources and screenshots
```

### Istio Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Istio using ArgoCD as a continuous deployment tool in an AWS EKS (Elastic Kubernetes Service) cluster. These configurations allow for declarative and automated management of Istio.

### Deployment with Helm
The `helm/` directory contains Helm charts and values for deploying Istio and its components. This method provides a standardized way to manage Istio installations and updates.

### Graphic Resources
The `imagenes/` directory contains screenshots, diagrams, and other visual resources that help document the architecture and operation of Istio in the environment.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the specific instructions for deployment in your environment
