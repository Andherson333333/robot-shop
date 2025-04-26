# Prometheus Stack con ArgoCD

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Acceso a las Interfaces](#acceso)
* [Monitoreo de Istio](#monitoreo-istio)
* [Limitaciones y Consideraciones](#limitaciones)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración para desplegar el Kube Prometheus Stack en un clúster Kubernetes utilizando ArgoCD. El stack incluye Prometheus, Grafana, AlertManager y otros componentes necesarios para una solución completa de monitoreo.

<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes funcionando (EKS)
- ArgoCD instalado y configurado
- Ingress Controller (nginx-internal)
- StorageClass `gp3-default` configurada

<a name="componentes"></a>
## Componentes
- **Prometheus**: Sistema de monitoreo y base de datos de series temporales
- **Grafana**: Plataforma de visualización y análisis de métricas
- **AlertManager**: Gestor de alertas para Prometheus
- **kube-state-metrics**: Exportador que genera métricas sobre el estado de objetos de Kubernetes
- **node-exporter**: Recopila métricas a nivel de nodo (hardware y SO)
- **Prometheus Operator**: Facilita la gestión de Prometheus en Kubernetes

<a name="estructura"></a>
## Estructura del Repositorio
```
.
└── argocd-prometheus.yml  # Definición de la aplicación ArgoCD para Prometheus Stack
```

<a name="configuracion"></a>
## Configuración

La configuración apunta al repositorio donde se encuentra el chart de Prometheus Stack y establece políticas de sincronización automática.

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-1.png)

<a name="instalacion"></a>
## Instalación

Para desplegar el stack de Prometheus con ArgoCD:

```bash
# Aplicar la definición de la aplicación
kubectl apply -f argocd-prometheus.yml

# Verificar que la aplicación se ha creado
kubectl get applications -n argocd
```

También puede crear la aplicación desde la interfaz web de ArgoCD:

1. Acceda a la UI de ArgoCD
2. Seleccione "New App"
3. Complete los campos según la configuración en argocd-prometheus.yml
4. Haga clic en "Create"

<a name="acceso"></a>
## Acceso a las Interfaces

Una vez desplegado, puede acceder a las interfaces a través de las siguientes URLs **únicamente desde dentro de la VPC**:

- **Prometheus**: https://dev1-prometheus.andherson33.click
- **Grafana**: https://dev1-grafana.andherson33.click
  - Usuario por defecto: admin
  - Contraseña por defecto: admin

### Importante: Acceso Únicamente Interno
Todos los servicios están configurados con el ingressClassName `nginx-internal`, lo que significa que:
- Solo son accesibles desde dentro de la VPC
- No están expuestos a Internet
- Para acceder desde fuera de la VPC, se requiere una conexión VPN o AWS Direct Connect

<a name="monitoreo-istio"></a>
## Monitoreo de Istio

La configuración incluye recursos para monitorear componentes de Istio:

1. **PodMonitor para Envoy**: Recopila métricas de los proxies de Istio (sidecars)
2. **ServiceMonitor para componentes de Istio**: Monitorea los componentes del plano de control de Istio

<a name="limitaciones"></a>
## Limitaciones y Consideraciones

### 1. Problemas con Nodos Saturados y Karpenter
Cuando se utiliza ArgoCD para desplegar Prometheus Stack en clústeres que utilizan Karpenter como escalador automático, pueden surgir problemas con el node-exporter en nodos que están saturados:

- **Problema**: El node-exporter puede fallar al desplegarse en nodos que están al límite de su capacidad
- **Impacto**: Pérdida de métricas a nivel de sistema para esos nodos

### 2. Limitación de Tamaño en ArgoCD
ArgoCD tiene una limitación con recursos de gran tamaño:

- **Problema**: El chart de Prometheus Stack genera manifiestos muy grandes (>256KB) que pueden exceder los límites de ArgoCD
- **Síntoma**: La aplicación no se sincroniza correctamente o muestra errores de sincronización



<a name="verificacion"></a>
## Verificación

Para verificar que el despliegue se ha realizado correctamente:

```bash
# Verificar el estado de la aplicación en ArgoCD
kubectl get application prometheus-stack -n argocd

# Verificar pods
kubectl get pods -n monitoring

# Verificar servicios
kubectl get svc -n monitoring

# Verificar ingress
kubectl get ingress -n monitoring
```

- Estado de sincronización en ArgoCD
![ArgoCD Sync](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-argocd.png)

- Pod servicios y pvc
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-2.png)

- Prometheus target
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-3.png)

- Verificación funcionamiento
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-4.png)
