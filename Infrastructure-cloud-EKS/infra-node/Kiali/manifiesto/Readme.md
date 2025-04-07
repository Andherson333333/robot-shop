# Kiali para Kubernetes

## Índice
1. [Descripción](#descripción)
2. [Componentes](#componentes)
3. [Requisitos](#requisitos)
4. [Características de la configuración](#características-de-la-configuración)
5. [Consideraciones de seguridad](#consideraciones-de-seguridad)
6. [Limitaciones de recursos](#limitaciones-de-recursos)
7. [Acceso](#acceso)
8. [Estructura de archivos](#estructura-de-archivos)
9. [Instrucciones de despliegue](#instrucciones-de-despliegue)
10. [Configuración personalizada](#configuración-personalizada)

## Descripción
Este repositorio contiene la configuración necesaria para desplegar Kiali, una consola de observabilidad para Istio Service Mesh en un cluster de Kubernetes.

## Componentes
La configuración incluye los siguientes recursos de Kubernetes:

- **ServiceAccount**: Cuenta de servicio para Kiali
- **ConfigMap**: Configuración de Kiali
- **ClusterRole**: Permisos a nivel de cluster para Kiali
- **ClusterRoleBinding**: Vincula el ClusterRole con el ServiceAccount de Kiali
- **Service**: Expone Kiali dentro del cluster
- **Deployment**: Despliega los pods de Kiali
- **Ingress**: Expone Kiali fuera del cluster a través de `kiali.andherson33.click`

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-1.png)

## Requisitos
- Kubernetes 1.19+
- Istio Service Mesh instalado
- Prometheus (configurado para la monitorización)
- Grafana (opcional, para dashboards adicionales)
- Controlador Ingress NGINX

## Características de la configuración
- Despliega Kiali v2.0
- Configurado para ejecutarse en nodos de infraestructura
- Autenticación anónima
- Integración con Prometheus en `http://prometheus-operator-kube-p-prometheus.monitoring:9090`
- Integración con Grafana en `http://prometheus-operator-grafana.monitoring:80`
- Exposición a través de Ingress con el nombre `kiali.andherson33.click`

## Consideraciones de seguridad
- Ejecuta Kiali con mínimos privilegios
- No inyecta el sidecar de Istio (`sidecar.istio.io/inject: "false"`)
- Usa `readOnlyRootFilesystem: true` y otras prácticas de seguridad

## Limitaciones de recursos
```yaml
resources:
  limits:
    memory: 1Gi
  requests:
    cpu: 10m
    memory: 64Mi
```

## Acceso
Una vez desplegado, Kiali estará disponible en:
- URL: `https://kiali.andherson33.click`
- Puerto interno: 20001
- Ruta base: `/kiali`

## Estructura de archivos
- `kiali.yaml`: Definición principal de Kiali (ServiceAccount, ConfigMap, ClusterRole, ClusterRoleBinding, Service, Deployment)
- `kiali-ingress.yaml`: Configuración del Ingress para acceso externo

## Instrucciones de despliegue

1. Asegúrate de tener el namespace `istio-system`:
```bash
kubectl create namespace istio-system
```

2. Aplica la configuración principal:
```bash
kubectl apply -f kiali.yaml
```

3. Aplica la configuración de Ingress:
```bash
kubectl apply -f kiali-ingress.yaml
```

## Verificacion 

4. Verifica el despliegue:
```bash
kubectl get pods -n istio-system | grep kiali
kubectl get ingress -n istio-system
```
- Pod y servicios
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-2.png)

- Verficacion conecion con grafana y prometheus
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-3.png)

- Funcionamiento con robot-shop
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Kiali/imagenes/kiali-5.png)

## Configuración personalizada

Para modificar la configuración, edita el ConfigMap en `kiali.yaml`. Algunos valores comunes a personalizar:
- Estrategia de autenticación
- URL de Prometheus
- URL de Grafana
- Número de réplicas
- Recursos asignados
