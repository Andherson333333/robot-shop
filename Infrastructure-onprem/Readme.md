# Kubernetes Production-Ready Practice Environment

## Descripción del Proyecto

Este repositorio implementa un ambiente de práctica orientado a producción, utilizando **Robot Shop** como aplicación de ejemplo para demostrar las mejores prácticas en Kubernetes. La implementación integra una suite completa de herramientas de observabilidad, monitoreo y despliegue continuo.

## Infraestructura Base

![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-2.png)

![pod-prometheus](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-1.png)

## Requistos

- Kubernetes cluster
- Helm
- NFS

## Estructura de Directorios
```
├── Argo-cd-Operator/          # Gestión de despliegues GitOps
├── Flagger-operator/          # Automatización de despliegues canary
├── Istio-operator/            # Service mesh 
├── Jaeger/                    # Distributed tracing
├── K8s/                       # Configuraciones base de Kubernetes
│                              # Específico para despliegues on-premise
├── Kiali/                     # Visualización de service mesh
├── Prometheus-operator/       # Monitoreo y alertas
└── loki+promtail/             # Agregación de logs
└── loadtest/                  # Generador trafico
```
## Despligue

Para desplegar este proyecto puede entrar en cada uno de los componenetes e instalarlos de forma individual hasta crear el entorno completo , el orden de despligue seria el siguiente :

- Istio-operator
- Prometheus-operator
- Jaeger
- Kiali
- loki+promtail
- Argo-cd-Operator
- Flagger-operator
- K8s

Tambine puede experimentar diferentes ordenes

# Verificacion

robot-shop

![robot-app-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-1.png)
![robot-app-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-4.png)
![robot-app-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-app-2.png)

pod y svc
![robot-app-1](https://github.com/Andherson333333/robot-shop/blob/master/image/robot-shop-4.png)


## Arquitectura General

### Aplicación de Ejemplo: **Robot Shop**
- Aplicación de microservicios que simula una tienda en línea.
- Implementa múltiples tecnologías y patrones de diseño.
- Ideal para demostrar capacidades de Kubernetes en producción.

## Stack de Observabilidad y Operaciones

### 1. Gestión de Despliegues (GitOps)
#### **Argo-cd-Operator/**
- Automatización de despliegues.
- Sincronización con repositorios Git.
- Control de versiones de configuraciones.
- Rollbacks automatizados.

### 2. Control de Tráfico y Despliegues Progresivos
#### **Flagger-operator/**
- Despliegues canary automatizados.
- Análisis de métricas en tiempo real.
- Rollbacks basados en métricas.
- Integración con service mesh.

### 3. Service Mesh y Visualización
#### **Istio-operator/**
- Control de tráfico avanzado.
- Políticas de seguridad.
- Métricas detalladas de red.

#### **Kiali/**
- Visualización del service mesh.
- Monitoreo de flujos de tráfico.
- Análisis de dependencias.

### 4. Observabilidad Completa
#### **Jaeger/**
- Trazabilidad distribuida.
- Análisis de latencia.
- Debugging de microservicios.

#### **Prometheus-operator/**
- Recolección de métricas.
- Alerting.
- Monitoreo de recursos.

#### **loki+promtail/**
- Agregación centralizada de logs.
- Búsqueda y análisis de logs.
- Correlación con métricas.

## Integración de Componentes

### Flujo de Operaciones
1. **Despliegue de Aplicaciones**
   - GitOps con Argo CD.
   - Control de versiones.
   - Automatización de despliegues.

2. **Control de Tráfico**
   - Service mesh con Istio.
   - Routing avanzado.
   - Políticas de seguridad.

3. **Monitoreo y Alertas**
   - Métricas con Prometheus.
   - Visualización con Kiali.
   - Trazabilidad con Jaeger.

4. **Gestión de Logs**
   - Centralización con Loki.
   - Recolección con Promtail.
   - Análisis y búsqueda.

## Beneficios de la Integración

- Observabilidad **end-to-end**.
- Automatización de operaciones.
- Control granular de despliegues.
- Monitoreo comprehensivo.
- Debugging efectivo.

## Casos de Uso

### **Prácticas DevOps**
- Implementación de CI/CD.
- Gestión de configuraciones.
- Automatización de operaciones.

### **Monitoreo y Troubleshooting**
- Análisis de performance.
- Detección de problemas.
- Debugging de microservicios.

### **Gestión de Tráfico**
- Despliegues canary.
- A/B testing.
- Control de acceso.
