# Configuración de Jaeger para Istio

Este repositorio contiene la configuración necesaria para implementar Jaeger como solución de rastreo (tracing) en un clúster de Kubernetes con Istio.

## Contenido

- [Descripción](#descripción)
- [Archivos de Configuración](#archivos-de-configuración)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Acceso a Jaeger UI](#acceso-a-jaeger-ui)
- [Configuración de Telemetría](#configuración-de-telemetría)
- [Almacenamiento](#almacenamiento)
- [Mantenimiento](#mantenimiento)

## Descripción

Este proyecto implementa Jaeger como sistema de rastreo distribuido para microservicios en un entorno Kubernetes con Istio. Permite recopilar, visualizar y analizar trazas de aplicaciones, facilitando la identificación de problemas de rendimiento y cuellos de botella en arquitecturas distribuidas.

## Archivos de Configuración

- **jaeger-ingress.yaml**: Configuración del Ingress para exponer la UI de Jaeger
- **jaeger.yml**: Despliegue completo de Jaeger, incluyendo:
  - Deployment de Jaeger All-in-One
  - Servicios para Jaeger Query, Collector y compatibilidad con Zipkin
  - PersistentVolumeClaim para almacenamiento de trazas
- **telemetry-robot.shop.yaml**: Configuración de telemetría para el namespace robot-shop

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/Jagger/imagenes/jagger-1.png)

## Requisitos

- Kubernetes 1.19+
- Istio instalado en el namespace `istio-system`
- Controlador de Ingress NGINX
- StorageClass `gp3-default` disponible en el clúster

## Instalación

1. Clonar este repositorio:
   ```bash
   git clone https://github.com/andherson33/jaeger-istio-config.git
   cd jaeger-istio-config
   ```

2. Aplicar las configuraciones:
   ```bash
   kubectl apply -f jaeger.yml
   kubectl apply -f jaeger-ingress.yaml
   ```

3. Para habilitar la telemetría en el namespace robot-shop:
   ```bash
   kubectl apply -f telemetry-robot.shop.yaml
   ```

## Acceso a Jaeger UI

La interfaz de Jaeger está disponible en:

- URL: https://jaeger.andherson33.click

Actualmente está configurado para uso interno (ingressClassName: nginx-internal). Para cambiar a acceso externo, modifique la configuración del Ingress descomentando la línea correspondiente.

## Configuración de Telemetría

La configuración de telemetría está configurada para el namespace `robot-shop` con un porcentaje de muestreo del 100%. Para aplicar telemetría a otros namespaces, cree un recurso Telemetry similar al proporcionado en `telemetry-robot.shop.yaml`.

```yaml
apiVersion: telemetry.istio.io/v1
kind: Telemetry
metadata:
  name: my-app-telemetry
  namespace: my-namespace
spec:
  tracing:
    - providers:
        - name: jaeger
      randomSamplingPercentage: 100.0
```

## Almacenamiento

Jaeger utiliza Badger como almacenamiento persistente con las siguientes características:

- Tipo de almacenamiento: Badger
- Tamaño del volumen: 10Gi
- Retención de datos: 24 horas
- Intervalo de mantenimiento: 15 minutos

## Mantenimiento

- El despliegue está configurado para ejecutarse en nodos de infraestructura con etiquetas específicas:
  - `node-type: infrastructure`
  - `workload-type: platform`
- Se aplican tolerancias para garantizar una programación adecuada
- Se establecen límites de recursos para garantizar un rendimiento estable

---

Para más información sobre Jaeger, consulte la [documentación oficial de Jaeger](https://www.jaegertracing.io/docs/latest/).
