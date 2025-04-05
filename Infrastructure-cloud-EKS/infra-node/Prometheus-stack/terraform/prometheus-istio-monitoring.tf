# Create istio-system namespace
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  # Ensure namespace is created after Prometheus
  depends_on = [helm_release.prometheus_stack]
}

# PodMonitor for collecting metrics from Envoy proxy
resource "kubectl_manifest" "istio_envoy_pod_monitor" {
  yaml_body = <<-YAML
    # PodMonitor for Envoy proxy metrics collection
    apiVersion: monitoring.coreos.com/v1
    kind: PodMonitor
    metadata:
      name: envoy-stats-monitor
      namespace: istio-system
      labels:
        monitoring: istio-proxies
        release: prometheus-stack
    spec:
      # Pod selector configuration
      selector:
        matchExpressions:
        - {key: istio-prometheus-ignore, operator: DoesNotExist}
      # Monitor pods in all namespaces
      namespaceSelector:
        any: true
      jobLabel: envoy-stats
      # Metrics endpoint configuration
      podMetricsEndpoints:
      - path: /stats/prometheus
        interval: 15s
        # Relabeling rules for metrics
        relabelings:
        # Keep only istio-proxy container metrics
        - action: keep
          sourceLabels: [__meta_kubernetes_pod_container_name]
          regex: "istio-proxy"
        # Keep only pods with prometheus.io/scrape annotation
        - action: keep
          sourceLabels: [__meta_kubernetes_pod_annotationpresent_prometheus_io_scrape]
        # Handle IPv6 addresses
        - action: replace
          regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
          replacement: '[$2]:$1'
          sourceLabels:
          - __meta_kubernetes_pod_annotation_prometheus_io_port
          - __meta_kubernetes_pod_ip
          targetLabel: address
        # Handle IPv4 addresses
        - action: replace
          regex: (\d+);((([0-9]+?)(\.|$)){4})
          replacement: $2:$1
          sourceLabels:
          - __meta_kubernetes_pod_annotation_prometheus_io_port
          - __meta_kubernetes_pod_ip
          targetLabel: address
        # Remove Kubernetes labels
        - action: labeldrop
          regex: "__meta_kubernetes_pod_label_(.+)"
        # Add namespace label
        - sourceLabels: [__meta_kubernetes_namespace]
          action: replace
          targetLabel: namespace
        # Add pod name label
        - sourceLabels: [__meta_kubernetes_pod_name]
          action: replace
          targetLabel: pod_name
  YAML
  # Ensure the monitor is created after the namespace
  depends_on = [kubernetes_namespace.istio_system]
}

# ServiceMonitor for Istio control plane components
resource "kubectl_manifest" "istio_control_plane_service_monitor" {
  yaml_body = <<-YAML
    # ServiceMonitor for Istio control plane components
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: istio-component-monitor
      namespace: istio-system
      labels:
        monitoring: istio-components
        release: prometheus-stack
    spec:
      jobLabel: istio
      targetLabels: [app]
      # Select Istio Pilot components
      selector:
        matchExpressions:
        - {key: istio, operator: In, values: [pilot]}
      # Monitor services in all namespaces
      namespaceSelector:
        any: true
      # Endpoint configuration
      endpoints:
      - port: http-monitoring
        interval: 15s
  YAML
  # Ensure the monitor is created after the namespace
  depends_on = [kubernetes_namespace.istio_system]
}
