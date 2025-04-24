> Spanish version of this README is available as ReadmeES.md

# AWS EBS CSI Driver Configuration for EKS

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [Components](#components)
* [Architecture](#architecture)
* [Implementation Configuration](#configuration)
* [Key Features](#features)
* [Deployment](#deployment)
* [Verification](#verification)

<a name="description"></a>
## General Description
This module implements the AWS EBS CSI Driver in the EKS cluster using the AWS Pod Identity system. It enables dynamic provisioning of EBS volumes for the cluster's Pods.

<a name="prerequisites"></a>
## Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- kubectl
- helm
- EKS deployed

<a name="components"></a>
## Components
- EBS CSI driver implementation using EKS add-ons
- Configured with Pod Identity for secure IAM permissions
- Default gp3 StorageClass created for dynamic provisioning
- Volumes encrypted by default using AWS KMS
- WaitForFirstConsumer binding mode to improve scheduling

<a name="architecture"></a>
## Architecture

![AWS EBS CSI Driver Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EBS/imagenes/ebs-1.png)

The EBS CSI driver consists of:
`Controller Pod:` Runs in the kube-system namespace and handles volume provisioning operations
`Node DaemonSet:` Runs on each node to handle volume attachment/detachment

The driver uses AWS Pod Identity for secure credential management without the need for IAM roles for service accounts.

<a name="configuration"></a>
## Implementation Configuration

### AWS EBS CSI Driver Add-on
The EBS CSI driver is implemented as an EKS add-on with Pod Identity:
```hcl
cluster_addons = {
….
  aws-ebs-csi-driver     = {service_account_role_arn = module.eks-pod-identity.iam_role_arn}
}
```

### Pod Identity Configuration
Pod Identity is used to grant the EBS CSI driver permissions to manage EBS volumes with the Terraform module:
```hcl
module "eks-pod-identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.9.0"
  
```

### Default StorageClass
A default StorageClass is created to enable dynamic provisioning of EBS volumes:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: gp3-default
provisioner: ebs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
parameters:
  type: gp3
  fsType: ext4
  encrypted: "true"
  kmsKeyId: alias/aws/ebs
```

<a name="features"></a>
## Key Features

### Default StorageClass Configuration
The `gp3-default` StorageClass provides the following features:
- **Volume Type**: gp3 (latest generation general-purpose SSD)
- **File System**: ext4
- **Encryption**: Enabled by default
- **KMS Key**: Uses the AWS-managed EBS KMS key
- **Expansion**: Volumes can be expanded without detaching
- **Deletion Policy**: Volumes are deleted when PVCs are deleted
- **Binding Mode**: WaitForFirstConsumer (improves pod scheduling)

<a name="deployment"></a>
## Deployment
1. Once EKS is deployed ([see EKS documentation](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/EKS/readme.md)), you can come to this section to deploy the EBS storage. Note that in this configuration, the pod identity components are already installed and ready to proceed.

2. To install the new added module:
   ```bash
   terraform init
   ```

3. Verify with terraform:
   ```bash
   terraform plan
   ```

4. Start the deployment:
   ```bash
   terraform apply
   ```

<a name="verification"></a>
## Verification

To verify that the EBS CSI driver is working correctly:

```
# Verify the EBS CSI add-on
kubectl get pods -n kube-system -l app=ebs-csi-controller

# Verify the StorageClass
kubectl get sc
```
