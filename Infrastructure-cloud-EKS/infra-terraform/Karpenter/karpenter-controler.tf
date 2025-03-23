# Karpenter Module
module "eks_karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.33.1"

  cluster_name                    = module.eks.cluster_name
  namespace                       = "karpenter"
  enable_pod_identity             = true
  create_pod_identity_association = true

  enable_spot_termination         = true
  enable_v1_permissions           = true

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
  depends_on = [kubectl_manifest.karpenter_namespace,data.aws_iam_role.spot]
}
