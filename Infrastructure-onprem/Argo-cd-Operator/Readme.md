
# Requisitos

- Kubernetes cluster
- Helm (para la instalación de argocd)

# Instalacion

1. Creacion namespace
```
kubectl create namespace argocd
```
2. Agregar repositorio helm
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```
3. Instalar con helm
```
helm install argocd argo/argo-cd \
  --namespace argocd \
```
4. Ahora para aplicar el manifiesto
```
```
# Verificacion


