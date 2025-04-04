resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "7.8.13"
  create_namespace = true

  # Configuración global para todos los componentes
  set {
    name  = "global.nodeSelector.node-type"
    value = "infrastructure"
  }

  set {
    name  = "global.nodeSelector.workload-type"
    value = "platform"
  }

  set {
    name  = "global.tolerations[0].key"
    value = "workload-type"
  }

  set {
    name  = "global.tolerations[0].value"
    value = "infrastructure"
  }

  set {
    name  = "global.tolerations[0].effect"
    value = "PreferNoSchedule"
  }

  # Server configuration - Habilitar modo inseguro para evitar redirecciones internas
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  # Dependencias
  depends_on = [
    helm_release.prometheus_stack,
    kubectl_manifest.karpenter_infra_node_pool
  ]
}

