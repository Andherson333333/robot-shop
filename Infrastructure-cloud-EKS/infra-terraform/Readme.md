> Spanish version of this README is available as ReadmeES.md

# Infra-Terraform: AWS EKS Base Infrastructure
## Table of Contents
1. [General Description](#general-description)
2. [Directory Structure](#directory-structure)
3. [Components](#components)
   - [EKS](#eks)
   - [EBS](#ebs)
   - [Karpenter](#karpenter)
   - [Loadbalancer-aws-nginx](#loadbalancer-aws-nginx)
4. [Deployment Method](#deployment-method)
5. [Recommended Deployment Order](#recommended-deployment-order)
6. [Prerequisites](#prerequisites)
7. [Additional Notes](#additional-notes)

## General Description
This directory contains all the base infrastructure needed to deploy an EKS cluster in AWS using Terraform. It includes the cluster definition, storage, auto-scaling, and load balancing.

## Directory Structure
```
.
├── EBS                      # EBS CSI driver for persistent storage
├── EKS                      # EKS cluster and VPC definition
├── Karpenter                # Automatic node auto-scaling
└── Loadbalancer-aws-nginx   # AWS LoadBalancer Controller and NGINX Ingress
```

## Components
Resources are created in a declarative and reproducible manner, allowing consistent management of infrastructure as code (IaC).

- `EKS`: Configuration of AWS Elastic Kubernetes Service cluster and associated network infrastructure.
- `EBS`: Configuration of the EBS CSI (Container Storage Interface) driver to provide persistent storage to the cluster.
- `Karpenter`: Node auto-scaling solution for Kubernetes that improves scaling efficiency and speed.
- `Loadbalancer-aws-nginx`: Configuration of the AWS Load Balancer Controller and NGINX Ingress for service exposure.

## Deployment Method
All infrastructure deployment is done using Terraform. For each component, the following procedure is followed:
```bash
# Navigate to the component directory
cd [component-directory]
# Initialize Terraform
terraform init
# Validate the configuration
terraform validate
# View the change plan
terraform plan
# Apply the changes
terraform apply
```

## Prerequisites
- AWS CLI configured with valid credentials
- Terraform ≥ v1.0
- kubectl configured
- Sufficient IAM permissions to create EKS, VPC, IAM Roles resources, etc.

## Recommended Deployment Order
For proper operation, it is recommended to deploy the components in the following order:
1. [EKS](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/EKS) - Base cluster and VPC
2. [EBS](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/EBS) - Persistent storage
3. [Karpenter](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/Karpenter) - Auto-scaling
4. [Loadbalancer-aws-nginx](https://github.com/Andherson333333/robot-shop/tree/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx) - Load balancing and ingress

## Additional Notes
- Each component includes documentation images in its `imagenes` directory that help understand its operation and configuration.
- Each directory contains its own README with specific configuration and deployment instructions.
- Default values are configured for a production environment but can be adapted as needed.
- It is recommended to review and adjust security configurations before deploying to a production environment.
