> Spanish version of this README is available as ReadmeES.md

# Robot Shop ArgoCD Configuration
## Table of Contents
* [General Description](#item1)
* [Requirements](#item2)
* [Installation](#item3)
* [Verification](#item4)

<a name="item1"></a>
## General Description
This repository contains the ArgoCD configuration for managing the automated deployment of Robot Shop, a microservices application that includes multiple components such as web, catalog, shopping cart, database, and more.

<a name="item2"></a>
## Requirements
- Kubernetes cluster v1.20+
- Helm v3+
- Kubectl configured to access the cluster

<a name="item3"></a>
## Installation
1. Create namespace
```
kubectl create namespace argocd
```
2. Add Helm repository
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```
3. Install with Helm
```
helm install argocd argo/argo-cd \
  --namespace argocd \
```
4. Once installed, we can verify the ArgoCD password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
5. Now apply the manifest, this manifest contains the path to K8s manifest
```
kubectl apply -f applicationset.yaml
```

<a name="item4"></a>
## Verification
After applying and installing ArgoCD, let's verify the application via UI
1.
![argocd-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-argocd-1.png)
2.
![argocd-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-argocd-2.png)
