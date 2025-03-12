module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"
  cluster_name    = local.name
  cluster_version = "1.32"
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access          = true
  enable_irsa                             = true

  # Configuración para evitar customer managed keys
  create_kms_key = false
  cluster_encryption_config = {
    resources = ["secrets"]
    provider_key_arn = "arn:aws:kms:${local.region}:${data.aws_caller_identity.current.account_id}:alias/aws/eks"
  }

  cluster_addons = {
    coredns                 = {}
    eks-pod-identity-agent  = {}
    kube-proxy              = {}
    vpc-cni                 = {}
    aws-ebs-csi-driver     = {service_account_role_arn = module.eks-pod-identity.iam_role_arn}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Istio security group rules
  node_security_group_additional_rules = {
    ingress_istio_webhook = {
      description                   = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol                      = "TCP"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_istio_workload = {
      description                   = "Cluster API to nodes ports/protocols for Istio"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_istio_discovery = {
      description                   = "Istio Discovery/XDS port"
      protocol                      = "TCP"
      from_port                     = 15010
      to_port                       = 15010
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_istio_monitoring = {
      description                   = "Istio Monitoring port"
      protocol                      = "TCP"
      from_port                     = 15014
      to_port                       = 15014
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  # Node groups configuration
  eks_managed_node_groups = {
    # Nodo de infraestructura
    Infrastructure = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 10
      desired_size   = 1

      labels = {
        "node-type" = "infrastructure"
        "workload-type" = "platform"
      }

      # Taint para reservar para workloads de infraestructura
      taints = {
        workload-type = {
          key    = "workload-type"
          value  = "infrastructure"
          effect = "PREFER_NO_SCHEDULE"
        }
      }
    }
  }

  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })
  tags = local.tags
}
