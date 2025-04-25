> Spanish version of this README is available as ReadmeES.md

# Istio with ArgoCD

## Table of Contents
* [General Description](#description)
* [Repository Structure](#structure)
* [Configuration](#configuration)
* [Installation](#installation)
* [Verification](#verification)

<a name="description"></a>
## General Description
This repository contains the configuration to deploy Istio Service Mesh in a Kubernetes cluster using ArgoCD as a Continuous Delivery tool. This configuration allows managing Istio in a declarative and automated way, following the GitOps approach.

<a name="structure"></a>
## Repository Structure
```
.
├── istio-helm.yaml    # ArgoCD application definition file for Istio
└── README.md          # This documentation
```

### istio-helm.yaml
This file defines the ArgoCD application to manage Istio:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: istio-helm
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Andherson333333/robot-shop.git
    targetRevision: HEAD
    path: Infrastructure-cloud-EKS/infra-node/Isitio-helm/helm
  destination:
    server: https://kubernetes.default.svc
    namespace: istio-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
  ignoreDifferences:
  - group: admissionregistration.k8s.io
    kind: ValidatingWebhookConfiguration
    jsonPointers:
    - /webhooks/0/failurePolicy
    - /webhooks/0/timeoutSeconds
    - /webhooks/0/matchPolicy
```

**Key features:**
- Points to the source repository that contains the Helm charts for Istio
- Configures automated synchronization with self-healing
- Automatically creates the istio-system namespace
- Ignores specific differences in webhooks to avoid conflicts during updates

<a name="configuration"></a>
## Configuration

The ArgoCD configuration for Istio includes the following elements:

- **Source**: Points to the repository and path where the Istio Helm chart is located
- **Destination**: Specifies the cluster (kubernetes.default.svc) and namespace (istio-system)
- **Sync Policies**:
  - `prune: true`: Removes resources that are no longer defined in Git
  - `selfHeal: true`: Reverts manual changes not declared in Git
  - `CreateNamespace: true`: Creates the namespace if it doesn't exist

**ignoreDifferences Configuration**:
The `ignoreDifferences` section is crucial to avoid issues with Istio's validation webhooks, as some fields may be modified by the Istio controller after deployment.

<a name="installation"></a>
## Installation

To implement Istio using ArgoCD:

```bash
# Make sure ArgoCD is installed and configured
kubectl get pods -n argocd

# Apply the application definition
kubectl apply -f istio-helm.yaml

# Verify that the application has been created in ArgoCD
kubectl get applications -n argocd
```

Alternatively, you can create the application from the ArgoCD web interface:

1. Access the ArgoCD UI
2. Select "New App"
3. Fill in the fields according to the configuration in istio-helm.yaml
4. Click "Create"

<a name="verification"></a>
## Verification

To verify that Istio has been installed correctly through ArgoCD:

```bash
# Verify the application's sync status
kubectl get application istio-helm -n argocd -o jsonpath='{.status.sync.status}'

# Verify that Istio pods are running
kubectl get pods -n istio-system

# Verify the application's health in ArgoCD
kubectl get application istio-helm -n argocd -o jsonpath='{.status.health.status}'
```

- Pods and services
![ArgoCD Istio](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-3.png)

- ArgoCD UI
![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-2.png)

- Istio Application
![Istio Resources](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/robot-shop-eks-2.png)
