> Spanish version of this README is available as ReadmeES.md

# Kiali - Observability Console for Istio
This repository contains configurations to deploy Kiali, the observability console for Istio Service Mesh, using two different methods.

## Repository Structure
The repository is organized as follows:
```
├── argocd/              # Configuration to deploy Kiali using ArgoCD
├── imagenes/            # Screenshots and diagrams
├── manifiesto/          # Kubernetes manifests for direct installation
└── README.md            # This documentation
```

## Deployment Methods
### Method 1: Direct Deployment with Manifests
The `manifiesto/` directory contains the YAML files needed to deploy Kiali directly to the Kubernetes cluster. This method is suitable for teams that prefer direct control over the installation.

### Method 2: Deployment using ArgoCD
The `argocd/` directory contains the configuration to deploy Kiali using ArgoCD as a GitOps tool. This approach allows for declarative and automated management of the installation.

## Getting Started
1. Choose the deployment method that best suits your needs
2. Navigate to the corresponding directory
3. Follow the instructions in the method-specific README

Consult the detailed documentation in each directory for specific installation and configuration instructions.
