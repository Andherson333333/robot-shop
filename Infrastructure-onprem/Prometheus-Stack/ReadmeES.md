## Índice de contenidos
* [Monitoreo con Prometheus & Istio](#item1)
* [Características](#item2)
* [Requistos](#item3)
* [Instalacion](#item4)
* [Verificacion](#item5)
* [Referencias](#item6)

<a name="item1"></a>
# Monitoreo con Prometheus & Istio

Este repositorio contiene la configuración necesaria para implementar Prometheus junto con Istio, proporcionando una solución robusta de monitoreo para clusters de Kubernetes.

<a name="item2"></a>
## Características

- Monitoreo automatizado de servicios Istio
- Almacenamiento persistente en NFS
- Dashboards preconfigurados en Grafana
- Recolección de métricas de Envoy Proxy

<a name="item3"></a>
## Requistos

- Helm
- NFS
- Kubernetes Cluster
- Istio 

<a name="item4"></a>
## Instalacion

1. Crear Namespace
```
kubectl create ns monitoring
```
2. Configurar Almacenamiento
```
kubectl apply -f pv-prometheus.yaml
```
3. Instalar Prometheus con helm
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
4. Aplicar el values , esta configurado para la integracion con istio y crear un pv , para guardar los datos en un NFS o ruta
```
helm install prometheus prometheus-community/kube-prometheus-stack -f values.yaml -n monitoring
```

6. Configurar Integración con Istio
```
kubectl apply -f prometheus-operator.yaml
```
6. Acceso a Interfaces
```
kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

<a name="item5"></a>
## Verificacion
- Prometheus pod 
![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-prometues-1.png)

- Promethues con istio Dashbord
![dashbord](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-prometues-3.png)

- Graphana 
![grapahan-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-graphana-2.png)
![graphana-2](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-graphana-1.png)

<a name="item7"></a>
## Referencias

- [Documentación oficial de Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Documentación de Istio](https://istio.io/latest/docs/ops/integrations/prometheus/)
- [Helm Charts de Prometheus](https://github.com/prometheus-community/helm-charts)
- [Documentación de Grafana](https://grafana.com/docs/grafana/latest/)

