# NodePool para infraestructura (Istio, ArgoCD, etc.)
resource "kubectl_manifest" "karpenter_infra_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: infrastructure
    spec:
      template:
        metadata:
          labels:
            node-type: infrastructure
            workload-type: platform
        spec:
          taints:
            - key: "workload-type"
              value: "infrastructure"
              effect: PreferNoSchedule
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          requirements:
            - key: "kubernetes.io/arch"
              operator: In
              values: ["amd64"]
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["on-demand"]
            - key: "topology.kubernetes.io/zone"
              operator: In
              values: ["${local.azs[0]}", "${local.azs[1]}"]
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["t", "m", "c", "r"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["3"]
            - key: "karpenter.k8s.aws/instance-size"
              operator: NotIn
              values: ["nano", "micro", "small"]
      limits:
        cpu: 8
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 5m
  YAML
  depends_on = [kubectl_manifest.karpenter_node_class]
}
