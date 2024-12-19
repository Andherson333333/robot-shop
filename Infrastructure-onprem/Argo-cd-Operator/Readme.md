# Robot Shop ArgoCD Configuration

## Índice de contenidos
* [Descripción General](#item1)
* [Requisitos](#item2)
* [Instalacion](#item3)
* [Verificacion](#item4)

<a name="item1"></a>
## Descripción General
Este repositorio contiene la configuración de ArgoCD para gestionar el despliegue automatizado de Robot Shop, una aplicación de microservicios que incluye múltiples componentes como web, catálogo, carrito de compras, base de datos y más.

<a name="item2"></a>
## Requisitos

- Kubernetes cluster
- Helm (para la instalación de argocd)

<a name="item3"></a>
## Instalacion

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
4. Una ves instalado podemos verificar la clave de argocd
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
4. Ahora para aplicar el manifiesto , este manifiesto contiene la ruta hacia K8s manifiesto
```
kubectl apply -f applicationset.yaml
```
<a name="item4"></a>
## Verificacion

Luego de aplicar e instalar el argocd vamso a verificar la aplicacion via UI
1.
![argocd-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-argocd-1.png)
2.
![argocd-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-argocd-2.png)



