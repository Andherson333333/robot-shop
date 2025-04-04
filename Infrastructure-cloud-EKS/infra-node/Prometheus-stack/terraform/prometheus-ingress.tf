# Custom Ingress for Prometheus
resource "kubectl_manifest" "prometheus_ingress" {
  yaml_body = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: prometheus-ingress
      namespace: monitoring
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        nginx.ingress.kubernetes.io/proxy-body-size: "0"
    spec:
      ingressClassName: nginx-external
      tls:
      - hosts:
        - dev1-prometheus.andherson33.click
      rules:
      - host: dev1-prometheus.andherson33.click
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-stack-kube-prom-prometheus
                port:
                  number: 9090
  YAML

  depends_on = [helm_release.prometheus_stack]
}

# Custom Ingress for Grafana
resource "kubectl_manifest" "grafana_ingress" {
  yaml_body = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: grafana-ingress
      namespace: monitoring
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        nginx.ingress.kubernetes.io/proxy-body-size: "0"
    spec:
      ingressClassName: nginx-external
      tls:
      - hosts:
        - dev1-grafana.andherson33.click
      rules:
      - host: dev1-grafana.andherson33.click
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-stack-grafana
                port:
                  number: 80
  YAML

  depends_on = [helm_release.prometheus_stack]
}
