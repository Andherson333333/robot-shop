> Spanish version of this README is available as ReadmeES.md

# Karpenter for EKS

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [Architecture](#architecture)
* [File Structure](#file-structure)
* [Node Types](#node-types)
* [Service Role for EC2 Spot](#spot-role)
* [Deployment](#deployment)
* [Verification](#verification)
* [Usage Examples](#examples)

<a name="description"></a>
## General Description
This module implements Karpenter, a node autoscaler for Kubernetes that allows scaling the cluster quickly and efficiently. Karpenter provisions nodes in response to pending pods' resource demands, improving efficiency and reducing costs.

<a name="prerequisites"></a>
## Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- kubectl
- EKS deployed
- AWS Load Balancer Controller (optional, for exposing services)

<a name="components"></a>
## Components
- Dedicated namespace for Karpenter
- Karpenter controller using Helm
- Pod Identity for secure IAM permissions
- EC2NodeClass for instance configuration
- NodePools for different types of workloads
- Service role for EC2 Spot instances

<a name="architecture"></a>
## Architecture

![Karpenter Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Karpenter/imagenes/karpenter-9.png)

Karpenter works by detecting pending pods that cannot be scheduled due to lack of resources, and automatically provisions new nodes that meet these pods' requirements.

<a name="file-structure"></a>
## File Structure

The Karpenter implementation is organized in the following files:

### `karpenter-namespace.tf`

Defines the dedicated namespace for Karpenter within the Kubernetes cluster. All Karpenter components are deployed in this namespace to maintain proper organization.

### `karpenter-controler.tf`

Configures the Karpenter controller using the official Terraform module. This file establishes:
- Karpenter's basic configuration
- Integration with Pod Identity for secure IAM permissions
- Enabling the Spot instance termination handler
- Additional IAM permissions needed for nodes

### `karpenter-helm.tf`

Implements the Karpenter Helm chart with specific configuration for our environment:
- Service account configuration
- Cluster name and endpoint configuration
- Interruption queue configuration for Spot instances

### `karpenter-nodepool.tf`

Defines the common EC2NodeClass for all NodePools, specifying:
- AMI family (Amazon Linux 2023)
- IAM role configuration
- Subnet and security group selectors based on tags
- Additional tags for discovery

### `karpenter_infra_node_pool.tf`

Configures the NodePool for infrastructure, intended for critical system components:
- Labels to identify infrastructure nodes
- Taints to prevent scheduling of general workloads
- Restriction to specific instance types
- Exclusive use of on-demand instances
- Resource limits and consolidation policies

### `karpenter_app_node_pool.tf`

Configures the NodePool for applications, intended for business workloads:
- Labels to identify application nodes
- No taints to allow scheduling of any workload
- Support for Spot and on-demand instances
- Broader resource limits

### `spot-rol-karpenter.tf`

This file is crucial for enabling the use of Spot instances in the cluster. It performs the following actions:
- Checks if the `AWSServiceRoleForEC2Spot` service role exists
- Creates the service-linked role if it doesn't exist
- Waits for the role to propagate in AWS
- References the role for use in other parts of the configuration

<a name="node-types"></a>
## Node Types

The implementation defines two main types of nodes that Karpenter can provision:

### 1. Infrastructure Nodes
These nodes are dedicated to critical platform workloads:

- **Purpose**: Run essential components like controllers, monitoring systems, and platform services
- **Labels**: `node-type: infrastructure` and `workload-type: platform`
- **Taints**: `workload-type=infrastructure:PreferNoSchedule`
- **Capacity Type**: Exclusively on-demand instances
- **Instance Types**: t3.medium, t3.large, t3.xlarge

### 2. Application Nodes
These nodes are designed for general workloads:

- **Purpose**: Run business applications and microservices
- **Labels**: `node-type: application` and `workload-type: business`
- **Taints**: None
- **Capacity Type**: Mix of on-demand and Spot instances
- **Instance Types**: t3.medium, t3.large

<a name="spot-role"></a>
## Service Role for EC2 Spot

The `spot-rol-karpenter.tf` file is particularly important as it configures the service role needed for AWS to manage Spot instances on behalf of the EKS cluster.

This service-linked role allows AWS to:
- Request and manage Spot instances in your account
- Handle Spot instance interruptions appropriately
- Ensure your workloads can migrate before Spot instances are terminated

The procedure uses the AWS CLI command to check if the role already exists and creates it if necessary, avoiding errors if it's already present. After creating or verifying the role, it waits 10 seconds to ensure the role propagates correctly across AWS services.

<a name="deployment"></a>
## Deployment

1. Make sure you have EKS deployed ([see EKS documentation](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/EKS/readme.md))

2. To install Karpenter:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

<a name="verification"></a>
## Verification

To verify that Karpenter is working correctly:

```bash
# Verify that Karpenter pods are running
kubectl get pods -n karpenter

# Verify that NodeClass and NodePools have been created correctly
kubectl get ec2nodeclasses
kubectl get nodepools

# Verify that the service role for Spot exists
aws iam get-role --role-name AWSServiceRoleForEC2Spot

# Verify that Karpenter has provisioned new nodes
kubectl get nodes --watch
```

<a name="examples"></a>
## Usage Examples

### Labels for Infrastructure Nodes
```yaml
nodeSelector:
  node-type: infrastructure
  workload-type: platform
```

### Labels and Tolerations for Infrastructure Nodes
```yaml
nodeSelector:
  node-type: infrastructure
  workload-type: platform
tolerations:
- key: "workload-type"
  operator: "Equal"
  value: "infrastructure"
  effect: "PreferNoSchedule"
```

### Labels for Application Nodes
```yaml
nodeSelector:
  node-type: application
```
