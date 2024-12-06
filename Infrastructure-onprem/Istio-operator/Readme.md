## Índice de contenidos
* [Istio ](#item1)
* [Requisitos](#item2)
* [Instalacion](#item3)
* [Verificacion](#item4)

<a name="item1"></a>
# Istio 

Este repositorio contiene la configuración necesaria para implementar Istio con helm , configurando los values para recoletar telemetria para que funcione con jagger , lo demas que por defecto

<a name="item1"></a>
## Requisitos

- Helm
- Kubernetes Cluster

<a name="item1"></a>
## Instalacion

1. Primero, agregue el repositorio de Helm de Istio
```
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```
3. Cree el namespace para Istio:
```
kubectl create namespace istio-system
```
4. Cree un archivo values.yaml
```
touch values.yaml
```
5. Instale Istio base
```
helm install istio-base istio/base \
  --namespace istio-system \
  --version 1.24.1
```
6. Instale Istiod (plano de control)
```
helm install istiod istio/istiod \
  --namespace istio-system \
  --values values.yaml \
  --version 1.24.1
```
7. Configuración explicada

- `enableTracing:` true: Activa la capacidad de trazabilidad en el mesh
- `extensionProviders:` Configura Jaeger como proveedor de trazabilidad
- `Puerto 4317:` Puerto estándar para OpenTelemetry
- El servicio apunta al colector de Jaeger en el namespace istio-system

## Verificacion

Una ves instalado verificamos pod y servicio , si hay algun error revisar logs y los pod

![istio-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-istio-2.png)









