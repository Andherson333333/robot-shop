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
- [Verificación](#verificación)
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
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-1.png)

## Requisitos
- Kubernetes 1.19+
- Istio instalado en el namespace `istio-system`
- Controlador de Ingress NGINX
- StorageClass `gp3-default` disponible en el clúster

## Instalación
1. Aplicar las configuraciones:
   ```bash
   kubectl apply -f argocd.-jagger.yml
 
   ```

```
## Almacenamiento
Jaeger utiliza Badger como almacenamiento persistente con las siguientes características:
- Tipo de almacenamiento: Badger
- Tamaño del volumen: 10Gi
- Retención de datos: 24 horas
- Intervalo de mantenimiento: 15 minutos

## Verificación
Para verificar que Jaeger está funcionando correctamente, siga estos pasos:

### Verificar la instalación
```bash
# Verificar que los pods de Jaeger están en ejecución
kubectl get pods -n istio-system -l app=jaeger

# Verificar los servicios de Jaeger
kubectl get svc -n istio-system -l app=jaeger

# Verificar el ingress
kubectl get ingress -n istio-system jaeger-query
```

### Comprobar la integración con Istio
```bash
# Verificar la configuración de telemetría
kubectl get telemetry -n robot-shop

# Comprobar que Istio está utilizando Jaeger como proveedor de trazas
kubectl get cm istio -n istio-system -o jsonpath='{.data.mesh}' | grep tracer
```

### Generar tráfico de prueba
Para verificar la captura de trazas, genere algo de tráfico hacia la aplicación:
```bash
# Ejecutar 10 solicitudes a un servicio de ejemplo
for i in {1..10}; do curl -s -o /dev/null http://frontend.robot-shop.svc.cluster.local; done
```

### Verificar trazas en la UI
1. Acceda a la UI de Jaeger en https://jaeger.andherson33.click
2. En el selector de servicio, elija alguno de los servicios del namespace robot-shop
3. Haga clic en "Find Traces" para visualizar las trazas recopiladas

- Verificacion de trazas de robot-shop aplicacion
![Jaeger UI Trazas](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-2.png)

![Jaeger UI Trazas](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-3.png)


La arquitectura implementada incluye:
- **Jaeger Collector**: Recibe las trazas desde los servicios instrumentados por Istio
- **Jaeger Query**: Proporciona la interfaz de usuario y las APIs para consultar trazas
- **Jaeger Agent**: Incluido en All-in-One, buffer local para trazas
- **Almacenamiento Badger**: Base de datos embebida para persistencia de trazas
- **Istio Proxy (Envoy)**: Inyecta automáticamente información de trazas en las peticiones

## Mantenimiento
- El despliegue está configurado para ejecutarse en nodos de infraestructura con etiquetas específicas:
  - `node-type: infrastructure`
  - `workload-type: platform`
- Se aplican tolerancias para garantizar una programación adecuada
- Se establecen límites de recursos para garantizar un rendimiento estable
---
Para más información sobre Jaeger, consulte la [documentación oficial de Jaeger](https://www.jaegertracing.io/docs/latest/).
