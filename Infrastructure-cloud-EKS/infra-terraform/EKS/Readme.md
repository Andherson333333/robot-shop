> Spanish version of this README is available as ReadmeES.md

# Amazon EKS Implementation

## Table of Contents
* [General Description](#description)
* [Prerequisites](#prerequisites)
* [File Structure](#structure)
* [Architecture](#architecture)
* [Main Components](#components)
* [Configuration](#configuration)
* [Deployment](#deployment)
* [Verification](#verification)
* [Next Steps](#next-steps)

<a name="description"></a>
## General Description
This module implements an Amazon EKS (Elastic Kubernetes Service) cluster following AWS best practices. The cluster is configured with a secure network structure, managed node groups, and essential add-ons for Kubernetes operation.

<a name="prerequisites"></a>
## Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- kubectl
- IAM permissions to create/manage EKS resources

<a name="structure"></a>
## File Structure

The EKS implementation is organized in the following files:

### `data.tf`
Contains the data sources necessary for implementation:
- Available AWS Availability Zones
- Authorization token for public ECR
- Caller's AWS account information

### `local.tf`
Defines local variables used in the configuration:
- Cluster name
- AWS region
- VPC CIDR
- Availability zones
- Common tags

### `provider.tf`
Configures the necessary Terraform providers:
- AWS (with specific version)
- Kubectl for managing Kubernetes resources
- Helm for installing charts
- Kubernetes for configuring resources in the cluster

### `vpc.tf`
Configures the virtual network (VPC) for the cluster:
- Public, private, and intra subnets
- NAT Gateway
- Internet Gateway
- Routing tables
- Tags required for Kubernetes and Karpenter

### `eks.tf`
Configures the EKS cluster and its components:
- Cluster version
- Security groups
- Cluster add-ons
- Managed node group
- Encryption configuration
- IRSA (IAM Roles for Service Accounts)

<a name="architecture"></a>
## Architecture

![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-6.png)

The cluster is designed with a focus on security, scalability, and maintainability:

- **Multiple availability zones** for high availability
- **Private subnets** for worker nodes
- **Public subnets** for resources that require direct Internet access
- **Intra subnets** for the EKS control plane
- **NAT Gateway** to allow Internet access from private subnets
- **Security groups** configured for traffic between cluster components

<a name="components"></a>
## Main Components

The EKS cluster includes the following main components:

### VPC and Networking
- Dedicated VPC with CIDR 10.0.0.0/16
- Public subnets for load balancers
- Private subnets for worker nodes
- Intra subnets for control plane communication
- NAT Gateway for Internet access from private subnets
- DNS hostnames and support enabled

### EKS Cluster
- Version 1.32 with public endpoint
- Administrator permissions for cluster creator
- IRSA (IAM Roles for Service Accounts) enabled
- Secrets encryption with KMS

### EKS Add-ons
- CoreDNS for internal DNS resolution
- kube-proxy for network routing
- Amazon VPC CNI for pod networking
- EBS CSI Driver for persistent storage
- Pod Identity Agent for authentication

### Managed Node Group
- Infrastructure type nodes with t3.medium instances
- Configured with taints for specific workloads
- Autoscaling configured (min: 1, max: 10, desired: 1)
- Labels to identify node types

### Security Rules
- Specifically configured to support Istio
- Allow communication between the control plane and nodes
- Enable necessary ports for Istio (15010, 15012, 15014, 15017)

<a name="deployment"></a>
## Deployment

To deploy the EKS cluster:

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. View the changes that will be applied:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Configure kubectl to connect to the cluster:
   ```bash
   aws eks update-kubeconfig --name my-eks --region us-east-1
   ```

<a name="verification"></a>
## Verification

To verify that the EKS cluster is working correctly:

```bash
# Verify cluster status
kubectl cluster-info

# Verify nodes
kubectl get nodes -o wide

# Verify system pods
kubectl get pods -n kube-system

# Verify installed add-ons
kubectl get pods -n kube-system -l k8s-app=kube-dns  # CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-proxy  # kube-proxy
kubectl get pods -n kube-system -l app=aws-node  # VPC CNI
kubectl get pods -n kube-system -l app=ebs-csi-controller  # EBS CSI Driver
```
- Eks AWS
![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-1.png)

- Internally cluster
![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-2.png)

- VPC
![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-3.png)

- Add on
![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-4.png)

- Cluster 
![Amazon EKS Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/EKS/imagenes/eks-5.png)
