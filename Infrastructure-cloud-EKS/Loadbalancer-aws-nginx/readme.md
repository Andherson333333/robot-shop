# Controladores de Ingress para EKS

## Índice
- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Componentes](#componentes)
  - [AWS Load Balancer Controller](#aws-load-balancer-controller)
  - [NGINX Ingress Controller Externo](#nginx-ingress-controller-externo)
  - [NGINX Ingress Controller Interno](#nginx-ingress-controller-interno)
- [Despliegue con Terraform](#despliegue-con-terraform)
  - [Archivos Principales](#archivos-principales)
  - [Instalación](#instalación)
- [Uso](#uso)
  - [Ingress Externo](#ingress-externo)
  - [Ingress Interno](#ingress-interno)
- [Consideraciones de Seguridad](#consideraciones-de-seguridad)
- [Solución de Problemas](#solución-de-problemas)
  - [Verificación de Recursos](#verificación-de-recursos)
  - [Problemas Comunes](#problemas-comunes)

## Descripción
Configuración de Terraform para implementar controladores de Ingress en Amazon EKS, permitiendo exponer servicios de Kubernetes a internet o a redes internas de manera segura y escalable.

## Arquitectura

![Arquitectura de Ingress Controllers](docs/ingress-architecture.png)

La arquitectura separa el tráfico externo e interno mediante dos controladores NGINX independientes:

- **Tráfico Externo**: Usuarios → NLB Externo → NGINX Controller Externo → Servicios Kubernetes
- **Tráfico Interno**: VPC → NLB Interno → NGINX Controller Interno → Servicios Kubernetes
- **Gestión**: AWS Load Balancer Controller administra los balanceadores en ambos flujos

## Componentes

### AWS Load Balancer Controller
- Gestiona balanceadores de carga AWS (ALB/NLB)
- Integración con ACM para TLS
- Utiliza EKS Pod Identity para permisos IAM

### NGINX Ingress Controller Externo
- Clase de ingress: `nginx-external`
- NLB público con terminación TLS
- Expone servicios a internet

### NGINX Ingress Controller Interno
- Clase de ingress: `nginx-internal`
- NLB interno con terminación TLS
- Accesible solo desde la VPC

## Despliegue con Terraform

### Archivos Principales

- **aws-lb-controler.tf**: Configura EKS Pod Identity y permisos IAM
- **aws-lb-helm.tf**: Instala el AWS Load Balancer Controller
- **nginx-helm-external.tf**: Configura el controlador NGINX externo
- **nginx-helm-internal.tf**: Configura el controlador NGINX interno

### Instalación

1. **Requisitos**
   - Terraform ≥ 1.0.0
   - AWS CLI configurado
   - kubectl instalado

2. **Despliegue**
   ```bash
   git clone https://github.com/tu-organizacion/eks-ingress-controllers.git
   cd eks-ingress-controllers
   terraform init
   terraform plan
   terraform apply
   ```

3. **Verificación**
   ```bash
   kubectl get pods -n kube-system | grep aws-load-balancer-controller
   kubectl get pods -n ingress-nginx-external
   kubectl get svc -n ingress-nginx-external
   ```

## Uso

### Ingress Externo

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

### Ingress Interno

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

## Consideraciones de Seguridad

- Terminación TLS en los balanceadores
- Tráfico HTTP redirigido a HTTPS
- Permisos IAM mínimos con EKS Pod Identity
- Ejecución en nodos de infraestructura dedicados

## Solución de Problemas

### Verificación de Recursos
```bash
# Ver controladores
kubectl get pods -n ingress-nginx-external
kubectl get pods -n ingress-nginx-internal

# Ver logs
kubectl logs -n ingress-nginx-external deployment/external-ingress-nginx-controller
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

### Problemas Comunes
- **Ingress no se crea**: Verificar clase de ingress (`nginx-external` o `nginx-internal`)
- **Certificados TLS**: Comprobar ARN en ACM y coincidencia con dominio
- **Balanceadores**: Revisar permisos IAM del controlador

