resource "helm_release" "prometheus_stack" {
  name             = "prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "70.0.2"

  # Global configuration for nodeSelector and tolerations
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

  # Prometheus Operator
  set {
    name  = "prometheusOperator.enabled"
    value = "true"
  }

  # Prometheus
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "15d"
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelector.matchLabels.release"
    value = "prometheus-stack"
  }
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelector.matchLabels.release"
    value = "prometheus-stack"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp3-default"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  # Grafana
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }
  set {
    name  = "grafana.persistence.storageClassName"
    value = "gp3-default"
  }
  set {
    name  = "grafana.persistence.size"
    value = "10Gi"
  }

  # Alertmanager
  set {
    name  = "alertmanager.enabled"
    value = "true"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.retention"
    value = "120h"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName"
    value = "gp3-default"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  # Simplified configuration for Node Exporter
  set {
    name  = "nodeExporter.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }
  set {
    name  = "nodeExporter.tolerations[0].operator"
    value = "Exists"
  }

  # Ingress
  set {
    name  = "ingress.prometheus.enabled"
    value = "false"
  }
  set {
    name  = "ingress.grafana.enabled"
    value = "false"
  }

  depends_on = [
    helm_release.external_nginx,
    kubectl_manifest.karpenter_infra_node_pool
  ]
}
