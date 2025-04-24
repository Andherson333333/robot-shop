> Spanish version of this README is available as ReadmeES.md

# Infra-Application: Business Applications

## Table of Contents
1. [General Description](#general-description)
2. [Deployment Methods](#deployment-methods)
   - [Deployment with Kubernetes Manifests](#deployment-with-kubernetes-manifests)
   - [Deployment with GitOps (ArgoCD)](#deployment-with-gitops-argocd)
3. [Additional Notes](#additional-notes)

## General Description
This directory contains the definitions and configurations of the business applications running on the EKS cluster. Currently, it contains the Robot Shop application, a microservices-based demonstration store.

## Deployment Methods
There are 2 deployment methods:

### Deployment with Kubernetes Manifests
All application components can be deployed directly using the provided Kubernetes manifests:

### Deployment with GitOps (ArgoCD)
The application is also configured to be deployed through ArgoCD. To use this method:
1. Ensure that ArgoCD is installed in the cluster
2. Synchronize the application to deploy all resources

## Additional Notes
- Each directory contains its own README with specific configuration and deployment instructions.
- Refer to the internal documentation for more details about the application and its architecture.
