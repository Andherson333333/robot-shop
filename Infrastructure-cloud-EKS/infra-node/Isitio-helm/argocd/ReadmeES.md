# Istio con ArgoCD

## Índice de contenidos
* [Descripción General](#descripcion)
* [Estructura del Repositorio](#estructura)
* [Configuración](#configuracion)
* [Instalación](#instalacion)
* [Verificación](#verificacion)

<a name="descripcion"></a>
## Descripción General
Este repositorio contiene la configuración para desplegar Istio Service Mesh en un clúster Kubernetes utilizando ArgoCD como herramienta de Continuous Delivery. Esta configuración permite gestionar Istio de manera declarativa y automatizada, siguiendo el enfoque GitOps.

<a name="estructura"></a>
## Estructura del Repositorio
```
.
├── istio-helm.yaml    # Archivo de definición de la aplicación ArgoCD para Istio
└── README.md          # Esta documentación
```

### istio-helm.yaml
Este archivo define la aplicación ArgoCD para gestionar Istio:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: istio-helm
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Andherson333333/robot-shop.git
    targetRevision: HEAD
    path: Infrastructure-cloud-EKS/infra-node/Isitio-helm/helm
  destination:
    server: https://kubernetes.default.svc
    namespace: istio-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
  ignoreDifferences:
  - group: admissionregistration.k8s.io
    kind: ValidatingWebhookConfiguration
    jsonPointers:
    - /webhooks/0/failurePolicy
    - /webhooks/0/timeoutSeconds
    - /webhooks/0/matchPolicy
```

**Características clave:**
- Apunta al repositorio de código fuente que contiene los charts de Helm para Istio
- Configura la sincronización automatizada con auto-sanación (selfHeal)
- Crea automáticamente el namespace istio-system
- Ignora diferencias específicas en webhooks para evitar conflictos durante las actualizaciones

<a name="configuracion"></a>
## Configuración

La configuración de ArgoCD para Istio incluye los siguientes elementos:

- **Origen**: Apunta al repositorio y ruta donde se encuentra el chart de Helm de Istio
- **Destino**: Especifica el cluster (kubernetes.default.svc) y namespace (istio-system)
- **Políticas de sincronización**:
  - `prune: true`: Elimina recursos que ya no están definidos en Git
  - `selfHeal: true`: Revierte cambios manuales no declarados en Git
  - `CreateNamespace: true`: Crea el namespace si no existe

**Configuración de ignoreDifferences**:
La sección `ignoreDifferences` es crucial para evitar problemas con los webhooks de validación de Istio, ya que algunos campos pueden ser modificados por el controlador de Istio después del despliegue.

<a name="instalacion"></a>
## Instalación

Para implementar Istio utilizando ArgoCD:

```bash
# Asegúrese de que ArgoCD está instalado y configurado
kubectl get pods -n argocd

# Aplique la definición de la aplicación
kubectl apply -f istio-helm.yaml

# Verifique que la aplicación se ha creado en ArgoCD
kubectl get applications -n argocd
```

Como alternativa, puede crear la aplicación desde la interfaz web de ArgoCD:

1. Acceda a la UI de ArgoCD
2. Seleccione "New App"
3. Complete los campos según la configuración en istio-helm.yaml
4. Haga clic en "Create"

<a name="verificacion"></a>
## Verificación

Para verificar que Istio se ha instalado correctamente a través de ArgoCD:

```bash
# Verificar el estado de sincronización de la aplicación
kubectl get application istio-helm -n argocd -o jsonpath='{.status.sync.status}'

# Verificar que los pods de Istio están ejecutándose
kubectl get pods -n istio-system

# Verificar la salud de la aplicación en ArgoCD
kubectl get application istio-helm -n argocd -o jsonpath='{.status.health.status}'
```

- Pod y servicios

![ArgoCD Istio](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-3.png)

- Argocd UI
![Arquitectura](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/istio-2.png)


- Aplicacion Istio
![Recursos Istio](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Isitio-helm/imagenes/robot-shop-eks-2.png)





