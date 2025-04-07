# Loki-Promtail Stack para Kubernetes

## Índice de contenidos
* [Descripción General](#descripcion)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Acceso a los Logs](#acceso)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este chart de Helm despliega Loki (sistema de almacenamiento y consulta de logs) y Promtail (agente para enviar logs) en un clúster Kubernetes. Proporciona una solución de registro centralizado liviana y eficiente, perfecta para entornos de Kubernetes.

<a name="estructura"></a>
## Estructura del Repositorio
```
.
├── Chart.yaml          # Definición y dependencias del chart
├── values1.yaml        # Configuración estándar
├── values2.yaml        # Configuración alternativa con affinity
└── README.md           # Esta documentación
```

<a name="configuracion"></a>
## Configuración
Este chart está basado en `loki-stack` y proporciona dos configuraciones diferentes:

### Configuración Estándar (values1.yaml)
- Loki se despliega en nodos de infraestructura
- Promtail se despliega en todos los nodos como DaemonSet
- Almacenamiento persistente de 10Gi para Loki
- Etiquetado de logs por namespace, pod, container y tipo (envoy/application)

### Configuración Alternativa (values2.yaml)
- Loki se despliega en nodos de infraestructura
- Promtail se despliega solo en nodos de aplicación (excluye nodos de infraestructura)
- Mismas capacidades de etiquetado que la configuración estándar

<a name="instalacion"></a>
## Instalación

```bash
# Crear el namespace
kubectl create namespace logging

# Actualizar dependencias
helm dependency update

# Instalar con la configuración estándar
helm install loki-stack . -n logging -f values1.yaml

# Alternativamente, instalar con la configuración alternativa
helm install loki-stack . -n logging -f values2.yaml
```

<a name="acceso"></a>
## Acceso a los Logs

Los logs pueden consultarse a través de:

- **Grafana**: Configurando un datasource de Loki en `http://loki-stack:3100`
- **API de Loki**: Accesible en `http://loki-stack:3100/loki/api/v1/query`

<a name="verificacion"></a>
## Verificación

Para verificar que Loki-Stack está funcionando correctamente:

### Verificar pods y servicios
```bash
# Verificar pods desplegados
kubectl get pods -n logging

# Verificar servicios
kubectl get svc -n logging

# Verificar volúmenes persistentes
kubectl get pvc -n logging
```
```bash
# Verificar que Promtail está recolectando logs
kubectl logs -n logging -l app=promtail -f

# Verificar que Loki está recibiendo datos
kubectl exec -it svc/loki-stack -n logging -- wget -qO- http://localhost:3100/ready
```

![Arquitectura]()
![Arquitectura]()
![Arquitectura]()
![Arquitectura]()



