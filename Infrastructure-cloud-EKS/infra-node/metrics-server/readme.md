# Metrics Server

## Índice de contenidos
* [Descripción General](#descripcion)
* [Requisitos Previos](#requisitos)
* [Componentes](#componentes)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Verificación](#verificacion)
* [Uso Común](#uso)
* [Solución de Problemas](#solucion-problemas)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración del Metrics Server para Kubernetes, un componente esencial que recopila métricas de recursos como CPU y memoria de los nodos y pods en el clúster. Estas métricas son utilizadas por componentes del clúster como el Horizontal Pod Autoscaler y el Vertical Pod Autoscaler.

![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/metrics-server/imagenes/metric-1.png)


<a name="requisitos"></a>
## Requisitos Previos
- Clúster Kubernetes funcionando (EKS)
- Helm 3.x instalado
- Nodos con etiqueta `node-type: infrastructure` para alojar el Metrics Server

<a name="componentes"></a>
## Componentes
- **Metrics Server**: Agregador de métricas de recursos del clúster que recopila datos de los Kubelets

<a name="estructura"></a>
## Estructura del Repositorio
```
.
├── Chart.yaml         # Definición del chart y dependencias
├── values.yaml        # Configuración personalizada del Metrics Server
└── README.md          # Esta documentación
```

<a name="configuracion"></a>
## Configuración

### Chart.yaml
Este archivo define las dependencias del chart, principalmente el Metrics Server.

### values.yaml
El archivo de valores contiene la configuración específica para el Metrics Server:

#### Configuración destacada:
- **ApiService**: Habilitado para registrar automáticamente el servicio API
- **Resolución de métricas**: Configurado para recopilar métricas cada 15 segundos
- **Seguridad TLS**: Configurado para aceptar conexiones inseguras con kubelets (--kubelet-insecure-tls)
- **NodeSelector**: Asegura que el Metrics Server se ejecute en nodos de infraestructura
- **Tolerations**: Permite que el pod se ejecute en nodos con taints específicos

<a name="instalacion"></a>
## Instalación

Para instalar el Metrics Server, ejecute:

```bash
# Actualizar las dependencias de Helm
helm dependency update

# Instalar el chart en el namespace kube-system
helm install metrics-server . -n kube-system
```

<a name="verificacion"></a>
## Verificación

Para verificar que el Metrics Server se ha instalado correctamente:

```bash
# Verificar que el pod está ejecutándose
kubectl get pods -n kube-system | grep metrics-server

# Verificar que el servicio API está registrado
kubectl get apiservices | grep metrics.k8s.io

# Comprobar que las métricas están siendo recopiladas
kubectl top nodes
kubectl top pods -A
```

<a name="uso"></a>
## Uso Común

El Metrics Server es utilizado principalmente para:

1. **Escalado Automático Horizontal (HPA)**:
   ```bash
   kubectl autoscale deployment mi-aplicacion --cpu-percent=80 --min=1 --max=10
   ```

2. **Monitoreo de recursos de nodos**:
   ```bash
   kubectl top nodes
   ```

3. **Monitoreo de recursos de pods**:
   ```bash
   kubectl top pods -A
   ```

<a name="solucion-problemas"></a>
## Solución de Problemas

Si encuentra problemas con el Metrics Server:

1. **Verificar el estado del pod**:
   ```bash
   kubectl describe pod -n kube-system -l k8s-app=metrics-server
   ```

2. **Revisar los logs**:
   ```bash
   kubectl logs -n kube-system -l k8s-app=metrics-server
   ```

3. **Comprobar conectividad con los kubelets**:
   Si los logs muestran problemas de conectividad con los kubelets, verifique:
   - Que las reglas de seguridad permiten el tráfico entre el Metrics Server y los kubelets
   - Que los certificados TLS están configurados correctamente (o que --kubelet-insecure-tls está habilitado)

4. **Problemas con `kubectl top`**:
   Si el comando `kubectl top` no funciona, verifique que el API Service está registrado:
   ```bash
   kubectl get apiservices v1beta1.metrics.k8s.io -o yaml
   ```
   
   El campo `status.conditions` debe mostrar `Available: True`
