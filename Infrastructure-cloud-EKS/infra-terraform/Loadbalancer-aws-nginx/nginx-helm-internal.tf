# Helm release for internal nginx ingress controller
resource "helm_release" "internal-nginx" {
  # Basic chart configuration
  name             = "internal"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx-internal"
  create_namespace = true
  version          = "4.12.0"
  # Configuration to install on infrastructure nodes
  set {
    name  = "controller.nodeSelector.node-type"
    value = "infrastructure"
  }
  set {
    name  = "controller.nodeSelector.workload-type"
    value = "platform"
  }
  # Tolerations for infrastructure taint
  set {
    name  = "controller.tolerations[0].key"
    value = "workload-type"
  }
  set {
    name  = "controller.tolerations[0].value"
    value = "infrastructure"
  }
  set {
    name  = "controller.tolerations[0].effect"
    value = "PreferNoSchedule"
  }
  # Ingress class configuration
  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-internal"
  }
  set {
    name  = "controller.ingressClassResource.controllerValue" 
    value = "k8s.io/ingress-nginx-internal"
  }
  set {
    name  = "controller.watchIngressWithoutClass"
    value = "false"
  }
  # AWS Load Balancer configuration
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = "arn:aws:acm:us-east-1:XXXXXXXXXXXX:certificate/XXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-deletion-protection"
    value = "false"
  }
  # Port configuration
  # set {
  #   name  = "controller.service.ports.http"
  #   value = "80"
  # }
  # set {
  #   name  = "controller.service.enableHttp"
  #   value = "true"
  # }
  set {
    name  = "controller.service.ports.https"
    value = "443"
  }
  # Explicitly disable HTTP
  set {
    name  = "controller.service.enableHttp"
    value = "false"
  }
  # SSL/TLS configuration
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "443"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "http"
  }
  # Additional configurations
  set {
    name  = "controller.config.use-forwarded-headers"
    value = "true"
  }
  depends_on = [helm_release.aws_lbc]
}
