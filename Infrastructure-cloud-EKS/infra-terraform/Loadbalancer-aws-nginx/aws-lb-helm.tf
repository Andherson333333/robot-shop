# Install helm AWS loadBalancer
resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.11.0"
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  # Configuration to install on infrastructure nodes
  set {
    name  = "nodeSelector.node-type"
    value = "infrastructure"
  }
  set {
    name  = "nodeSelector.workload-type"
    value = "platform"
  }
  # Tolerations for infrastructure taint
  set {
    name  = "tolerations[0].key"
    value = "workload-type"
  }
  set {
    name  = "tolerations[0].value"
    value = "infrastructure"
  }
  set {
    name  = "tolerations[0].effect"
    value = "PreferNoSchedule"
  }
  depends_on = [
    module.aws_lb_controller_pod_identity
  ]
}
