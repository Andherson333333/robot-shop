> Spanish version of this README is available as ReadmeES.md

# Jaeger - Configuration and Deployment
This repository contains configurations for deploying and managing Jaeger in Kubernetes environments, with two different deployment methods.

## Repository Structure
The repository is organized as follows:
```
├── argocd/                     # Deployment using ArgoCD
├── imagenes/                   # Graphic resources and screenshots
├── manifiesto/                 # Deployment using Kubernetes manifests
```

### Method 1: Deployment with Kubernetes Manifests
The `manifiesto/` directory contains the Kubernetes YAML files needed to deploy Jaeger directly using kubectl. This method is suitable for environments where direct control over the installation is preferred or where ArgoCD is not available.

### Method 2: Deployment with ArgoCD
The `argocd/` directory contains configurations for deploying Jaeger using ArgoCD as a continuous deployment tool. This method provides a declarative, automated, and GitOps-based management to maintain the Jaeger installation.

### Graphic Resources
The `imagenes/` directory contains screenshots, diagrams, and other visual resources that help document the architecture and operation of Jaeger in the environment.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the specific instructions for deployment in your environment
