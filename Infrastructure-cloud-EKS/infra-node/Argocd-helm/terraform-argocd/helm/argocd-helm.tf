resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "7.7.13"
  create_namespace = true

  # Configuración para desplegar en nodos de infraestructura
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

  # Redis configuration
  set {
    name  = "redis.enabled"
    value = "true"
  }

  set {
    name  = "redis.persistence.enabled"
    value = "true"
  }

  set {
    name  = "redis.persistence.storageClass"
    value = "gp3-default"
  }

  set {
    name  = "redis.persistence.size"
    value = "10Gi"
  }

  set {
    name  = "redis.persistence.accessMode"
    value = "ReadWriteOnce"
  }

  # Server configuration
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  depends_on = [
    helm_release.external_nginx,
    kubectl_manifest.karpenter_infra_node_pool
  ]
}
