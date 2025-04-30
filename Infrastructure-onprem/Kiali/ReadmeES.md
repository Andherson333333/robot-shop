## Índice de contenidos
* [Configuración de Kiali con Istio ](#item1)
* [Requistos](#item2)
* [Instalacion ](#item3)
* [Verificacion](#item4)

<a name="item1"></a>
# Configuración de Kiali con Istio 

## Descripción General
Esta documentación cubre la configuración de Kiali con Istio, incluyendo la integración con Grafana y Prometheus para monitoreo y observabilidad.

<a name="item2"></a>
## Requistos

- Kubernetes Cluster
- Istio (Tenerlo instalado)

<a name="item3"></a>
## Instalacion 

1. Deployar el manifiesto de kiali.yaml (fuente original )
```
kubectl apply -f kiali.yaml
```
3. Luego de desplegar como se instalo promethues operator va dar error asi que se agregar endpoint al confimap de kaili
```
kubectl edit configmap kiali -n istio-system
```
Esto lo que va dentro del configmap en la secion external_service
```
 external_services:
      custom_dashboards:
        enabled: true
      prometheus:
        url: http://prometheus-kube-prometheus-prometheus.monitoring:9090
      grafana:
        external_url: http://prometheus-grafana.monitoring:80
        in_cluster_url: http://prometheus-grafana.monitoring:80
      istio:
        root_namespace: istio-system
      tracing:
        enabled: false

```
![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-kiali-2.png)

<a name="item4"></a>
## Verificacion

Una ves configurado y la aplicacion emepiza a reciber paquetes , ya empieza a monstrala

![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-kiali-1.png)



