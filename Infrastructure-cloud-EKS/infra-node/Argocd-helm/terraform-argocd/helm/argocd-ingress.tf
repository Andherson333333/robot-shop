resource "kubectl_manifest" "ingress_webhook" {
  yaml_body = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: argocd-webhook-ingress
      namespace: argocd
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        nginx.ingress.kubernetes.io/proxy-body-size: "0"
    spec:
      ingressClassName: nginx-external
      tls:
      - hosts:
        - argocd.andherson33.click
      rules:
      - host: argocd.andherson33.click
        http:
          paths:
          - path: /api/webhook
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
  YAML
  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "ingress" {
  yaml_body = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: argocd-ingress
      namespace: argocd
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        nginx.ingress.kubernetes.io/proxy-body-size: "0"
    spec:
      ingressClassName: nginx-external    # Para cambiar a interno, comentar esta línea y descomentar la siguiente
      # ingressClassName: nginx-internal  # Para uso interno
      tls:
      - hosts:
        - argocd.andherson33.click
      rules:
      - host: argocd.andherson33.click
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
  YAML
  depends_on = [helm_release.argocd]
}
