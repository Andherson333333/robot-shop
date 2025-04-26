# Prometheus Stack con Terraform

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
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración para desplegar el Kube Prometheus Stack en un clúster Kubernetes utilizando Terraform. El stack incluye Prometheus, Grafana, AlertManager y otros componentes necesarios para una solución completa de monitoreo.

<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes funcionando (EKS)
- Terraform >= 1.0.0
- Provider kubernetes configurado
- Provider helm configurado
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
├── prometheus-stack-helm.tf      # Configuración de Terraform para el despliegue del Helm chart
├── prometheus-ingress.tf         # Configuración de Ingress para Prometheus y Grafana
├── prometheus-istio-monitoring.tf # Configuración para monitoreo de Istio
└── README.md                      # Esta documentación
```

<a name="configuracion"></a>
## Configuración

### prometheus-stack-helm.tf
Este archivo contiene la configuración del recurso `helm_release` para desplegar el chart de kube-prometheus-stack. Incluye variables para configurar almacenamiento, retención, y selección de nodos.

### prometheus-ingress.tf
Define los recursos de Ingress para acceder a Prometheus y Grafana.

### prometheus-istio-monitoring.tf
Configura ServiceMonitor y PodMonitor para monitorear componentes de Istio.

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Prometheus-stack/imagenes/prometheus-1.png)

<a name="instalacion"></a>
## Instalación

Para instalar el stack de Prometheus con Terraform:

```bash
# Inicializar el directorio de trabajo de Terraform
terraform init

# Verificar los cambios a aplicar
terraform plan

# Aplicar la configuración
terraform apply
```

<a name="acceso"></a>
## Acceso a las Interfaces

Una vez desplegado, puede acceder a las interfaces a través de las siguientes URLs **únicamente desde dentro de la VPC**:

- **Prometheus**: https://dev1-prometheus.andherson33.click
- **Grafana**: https://dev1-grafana.andherson33.click
  - Usuario por defecto: admin

### Importante: Acceso Únicamente Interno
Todos los servicios están configurados con el ingressClassName `nginx-internal`, lo que significa que:
- Solo son accesibles desde dentro de la VPC
- No están expuestos a Internet
- Para acceder desde fuera de la VPC, se requiere una conexión VPN o AWS Direct Connect

<a name="monitoreo-istio"></a>
## Monitoreo de Istio

La configuración en `prometheus-istio-monitoring.tf` incluye:

1. **PodMonitor para Envoy**: Recopila métricas de los proxies de Istio (sidecars)
2. **ServiceMonitor para componentes de Istio**: Monitorea los componentes del plano de control de Istio

<a name="personalizacion"></a>
## Personalización

Para personalizar la configuración:

1. Modifique los archivos `.tf` según sus necesidades
2. Aplique los cambios con:
   ```bash
   terraform apply
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

1. Verifique el resultado de `terraform apply` para identificar errores
2. Verifique que todos los pods estén en estado Running:
   ```bash
   kubectl get pods -n monitoring
   ```
3. Revise los logs de los pods con problemas:
   ```bash
   kubectl logs -n monitoring <nombre-del-pod>
   ```
4. Compruebe que los Ingress estén correctamente configurados:
   ```bash
   kubectl get ingress -n monitoring
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
