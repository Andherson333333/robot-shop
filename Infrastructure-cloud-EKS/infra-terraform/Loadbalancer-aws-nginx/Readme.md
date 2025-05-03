> Spanish version of this README is available as ReadmeES.md

# Ingress Controllers for EKS

## Table of Contents
- [Description](#description)
- [Architecture](#architecture)
- [Components](#components)
  - [AWS Load Balancer Controller](#aws-load-balancer-controller)
  - [External NGINX Ingress Controller](#external-nginx-ingress-controller)
  - [Internal NGINX Ingress Controller](#internal-nginx-ingress-controller)
- [Deployment with Terraform](#deployment-with-terraform)
  - [Main Files](#main-files)
  - [Installation](#installation)
- [Usage](#usage)
  - [External Ingress](#external-ingress)
  - [Internal Ingress](#internal-ingress)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
  - [Resource Verification](#resource-verification)
  - [Common Issues](#common-issues)

## Description
Terraform configuration to implement Ingress controllers in Amazon EKS, allowing Kubernetes services to be exposed to the internet or internal networks in a secure and scalable way.

## Architecture

![Ingress Controllers Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx/imagenes/loadbalancer-1.png)

The architecture separates external and internal traffic through two independent NGINX controllers:

- **External Traffic**: Users → External NLB → External NGINX Controller → Kubernetes Services
- **Internal Traffic**: VPC → Internal NLB → Internal NGINX Controller → Kubernetes Services
- **Management**: AWS Load Balancer Controller manages the load balancers in both flows

## Components

### AWS Load Balancer Controller
- Manages AWS load balancers (ALB/NLB)
- Integration with ACM for TLS
- Uses EKS Pod Identity for IAM permissions

### External NGINX Ingress Controller
- Ingress class: `nginx-external`
- Public NLB with TLS termination
- Exposes services to the internet

### Internal NGINX Ingress Controller
- Ingress class: `nginx-internal`
- Internal NLB with TLS termination
- Accessible only from the VPC

## Deployment with Terraform

### Main Files

- **aws-lb-controler.tf**: Configures EKS Pod Identity and IAM permissions
- **aws-lb-helm.tf**: Installs the AWS Load Balancer Controller
- **nginx-helm-external.tf**: Configures the external NGINX controller
- **nginx-helm-internal.tf**: Configures the internal NGINX controller

### Installation

Note: Command to search for already configured ACM certificate ```aws acm list-certificates --region us-east-1```

1. **Requirements**
   - Terraform ≥ 1.0.0
   - AWS CLI configured
   - kubectl installed

2. **Deployment**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Verification**
   ```bash
   kubectl get pods -n kube-system | grep aws-load-balancer-controller
   kubectl get pods -n ingress-nginx-external
   kubectl get svc -n ingress-nginx-external
   ```

## Usage

### External Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-app
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx-external
  tls:
  - hosts:
    - app.example.com
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
```

### Internal Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: internal-service
spec:
  ingressClassName: nginx-internal
  tls:
  - hosts:
    - service.internal
  rules:
  - host: service.internal
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: internal-service
            port:
              number: 80
```

## Security Considerations

- TLS termination at load balancers
- HTTP traffic redirected to HTTPS
- Minimal IAM permissions with EKS Pod Identity
- Execution on dedicated infrastructure nodes

## Troubleshooting

### Resource Verification
```bash
# View controllers
kubectl get pods -n ingress-nginx-external
kubectl get pods -n ingress-nginx-internal

# View logs
kubectl logs -n ingress-nginx-external deployment/external-ingress-nginx-controller
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

- Deployment of both internal and external load balancers
![loadbalancer](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx/imagenes/loadbalancer-2.png)

- Direction only for port 443
![loadbalancer](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx/imagenes/loadbalancer-3.png)

- Internet-facing load balancer
![loadbalancer](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx/imagenes/loadbalancer-4.png)

- Direction only to port 443
![loadbalancer](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-terraform/Loadbalancer-aws-nginx/imagenes/loadbalancer-5.png)

### Common Issues
- **Ingress not created**: Verify ingress class (`nginx-external` or `nginx-internal`)
- **TLS certificates**: Check ARN in ACM and domain match
- **Load balancers**: Review controller's IAM permissions
