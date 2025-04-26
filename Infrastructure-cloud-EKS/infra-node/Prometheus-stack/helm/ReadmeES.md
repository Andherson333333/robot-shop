# Prometheus Stack

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Acceso a las Interfaces](#acceso)
* [Monitoreo de Istio](#monitoreo-istio)
* [Personalización](#personalizacion)
* [Consideraciones de Recursos](#recursos)
* [Solución de Problemas](#solucion-problemas)
* [Mantenimiento](#mantenimiento)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración del Kube Prometheus Stack para monitoreo de clústeres Kubernetes. El stack incluye Prometheus, Grafana, AlertManager y otros componentes necesarios para una solución completa de monitoreo.

<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes funcionando (EKS)
- Helm 3.x instalado
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
├── Chart.yaml
├── templates/
│   └── ingress.yaml                         # Configuración de ingress para Prometheus y Grafana
│   └── prometheus-operator-istior.yaml      # Configuracion Istio para prometheus
├── values.yaml                              # Configuración personalizada del stack
└── README.md                                # Esta documentación
```

<a name="configuracion"></a>
## Configuración

### Chart.yaml
Este archivo define las dependencias del chart, principalmente el kube-prometheus-stack.

### values.yaml
El archivo de valores contiene la configuración específica para cada componente del stack. Aspectos destacados:

- **Configuración de Nodos**: Todos los componentes se ejecutan en nodos de infraestructura con etiqueta `node-type: infrastructure` excepto el node-exporter que debe ejecutarse en todos los nodos.
- **Almacenamiento**: Todos los componentes que requieren persistencia utilizan la clase de almacenamiento `gp3-default`.
- **Retención**: Prometheus conserva las métricas durante 15 días.
- **Acceso**: Se configura mediante Ingress interno para acceder a Prometheus y Grafana exclusivamente desde dentro de la VPC.

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-1.png)


<a name="instalacion"></a>
## Instalación

Para instalar el stack de Prometheus, ejecute:

```bash
# Crear el namespace
kubectl create namespace monitoring

# Actualizar las dependencias de Helm
helm dependency update

# Instalar el chart
helm install prometheus-stack . -n monitoring
```

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

Este chart incluye configuraciones para monitorear componentes de Istio:

1. **PodMonitor para Envoy**: Recopila métricas de los proxies de Istio (sidecars)
2. **ServiceMonitor para componentes de Istio**: Monitorea los componentes del plano de control de Istio

<a name="personalizacion"></a>
## Personalización

Para personalizar la configuración:

1. Modifique el archivo `values.yaml` según sus necesidades
2. Actualice el chart con:
   ```bash
   helm upgrade prometheus-stack . -n monitoring
   ```

<a name="recursos"></a>
## Consideraciones de Recursos

Los componentes tienen las siguientes necesidades de almacenamiento:

- **Prometheus**: 10Gi
- **Grafana**: 10Gi
- **AlertManager**: 10Gi

Asegúrese de que su clúster tenga suficientes recursos disponibles.

<a name="solucion-problemas"></a>
## Solución de Problemas

Si encuentra problemas con el despliegue:

1. Verifique que todos los pods estén en estado Running:
   ```bash
   kubectl get pods -n monitoring
   ```

2. Revise los logs de los pods con problemas:
   ```bash
   kubectl logs -n monitoring <nombre-del-pod>
   ```

3. Compruebe que los Ingress estén correctamente configurados:
   ```bash
   kubectl get ingress -n monitoring
   ```

4. Para problemas de acceso:
   ```bash
   # Verificar que está utilizando el ingress-controller interno
   kubectl get ingress -n monitoring -o wide
   
   # Verificar que está accediendo desde dentro de la VPC
   # Puede usar un pod temporal para probar:
   kubectl run curl-test --image=curlimages/curl -i --tty -- sh
   curl -k https://dev1-prometheus.andherson33.click
   ```

<a name="mantenimiento"></a>
## Mantenimiento

Para actualizar el stack a una nueva versión:

1. Actualice la versión de `kube-prometheus-stack` en el archivo `Chart.yaml`
2. Ejecute:
   ```bash
   helm dependency update
   helm upgrade prometheus-stack . -n monitoring
   ```

<a name="verificacion"></a>
## Verificación

Para verificar que el despliegue se ha realizado correctamente:

```bash
# Verificar pods
kubectl get pods -n monitoring
```

```bash
# Verificar servicios
kubectl get svc -n monitoring
```

```bash
# Verificar ingress
kubectl get ingress -n monitoring
```

```bash
# Verificar PVCs
kubectl get pvc -n monitoring
```

```bash
# Verificar monitores
kubectl get servicemonitor -n istio-system
```

```bash
# Verificar monitores de pods
kubectl get podmonitor -n istio-system
```

- Pod servicios y pvc
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-2.png)

- Prometheus target
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-3.png)

- Lista de dasbord

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-5.png)

- Verificación funcionamiento
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-4.png)

