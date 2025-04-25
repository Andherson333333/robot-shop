> Spanish version of this README is available as ReadmeES.md

# Kubecost - Configuration and Deployment
This repository contains configurations for deploying Kubecost in different environments.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Deployment configurations using ArgoCD
├── helm/                       # Deployment with Helm
├── imagenes/                   # Graphic resources and screenshots
```

### Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Kubecost using ArgoCD as a continuous deployment tool in an AWS EKS (Elastic Kubernetes Service) cluster. These configurations allow for declarative and automated management of Kubecost.

### Deployment with Helm
The `helm/` directory contains Helm charts and values for deploying Kubecost and its components. This method provides a standardized way to manage Kubecost installations and updates.

### Graphic Resources
The `imagenes/` directory contains screenshots, diagrams, and other visual resources that help document the architecture and operation of Kubecost in the environment.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the specific instructions for deployment in your environment
