> Spanish version of this README is available as ReadmeES.md

# Jaeger Configuration for Istio
This repository contains the necessary configuration to implement Jaeger as a tracing solution in a Kubernetes cluster with Istio.

## Contents
- [Description](#description)
- [Configuration Files](#configuration-files)
- [Requirements](#requirements)
- [Installation](#installation)
- [Accessing Jaeger UI](#accessing-jaeger-ui)
- [Telemetry Configuration](#telemetry-configuration)
- [Storage](#storage)
- [Verification](#verification)
- [Maintenance](#maintenance)

## Description
This project implements Jaeger as a distributed tracing system for microservices in a Kubernetes environment with Istio. It allows collecting, visualizing, and analyzing application traces, facilitating the identification of performance issues and bottlenecks in distributed architectures.

## Configuration Files
- **jaeger-ingress.yaml**: Ingress configuration to expose the Jaeger UI
- **jaeger.yml**: Complete Jaeger deployment, including:
  - Jaeger All-in-One Deployment
  - Services for Jaeger Query, Collector, and Zipkin compatibility
  - PersistentVolumeClaim for trace storage
- **telemetry-robot.shop.yaml**: Telemetry configuration for the robot-shop namespace

![Architecture](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-1.png)

## Requirements
- Kubernetes 1.19+
- Istio installed in the `istio-system` namespace
- NGINX Ingress Controller
- StorageClass `gp3-default` available in the cluster

## Installation
1. Apply the configurations:
   ```bash
   kubectl apply -f jaeger.yml
   kubectl apply -f jaeger-ingress.yaml
   ```
3. To enable telemetry in the robot-shop namespace:
   ```bash
   kubectl apply -f telemetry-robot.shop.yaml
   ```

## Accessing Jaeger UI
The Jaeger interface is available at:
- URL: https://jaeger.andherson33.click
It is currently configured for internal use (ingressClassName: nginx-internal). To change to external access, modify the Ingress configuration by uncommenting the corresponding line.

## Telemetry Configuration
The telemetry configuration is set up for the `robot-shop` namespace with a 100% sampling percentage. To apply telemetry to other namespaces, create a similar Telemetry resource as provided in `telemetry-robot.shop.yaml`.
```yaml
apiVersion: telemetry.istio.io/v1
kind: Telemetry
metadata:
  name: my-app-telemetry
  namespace: my-namespace
spec:
  tracing:
    - providers:
        - name: jaeger
      randomSamplingPercentage: 100.0
```

## Storage
Jaeger uses Badger as persistent storage with the following characteristics:
- Storage type: Badger
- Volume size: 10Gi
- Data retention: 24 hours
- Maintenance interval: 15 minutes

## Verification
To verify that Jaeger is working correctly, follow these steps:

### Verify the installation
```bash
# Verify that Jaeger pods are running
kubectl get pods -n istio-system -l app=jaeger

# Verify Jaeger services
kubectl get svc -n istio-system -l app=jaeger

# Verify the ingress
kubectl get ingress -n istio-system jaeger-query
```

### Check Istio integration
```bash
# Verify telemetry configuration
kubectl get telemetry -n robot-shop

# Check that Istio is using Jaeger as the trace provider
kubectl get cm istio -n istio-system -o jsonpath='{.data.mesh}' | grep tracer
```

### Generate test traffic
To verify trace capture, generate some traffic to the application:
```bash
# Run 10 requests to an example service
for i in {1..10}; do curl -s -o /dev/null http://frontend.robot-shop.svc.cluster.local; done
```

### View traces in the UI
1. Access the Jaeger UI at https://jaeger.andherson33.click
2. In the service selector, choose one of the services from the robot-shop namespace
3. Click "Find Traces" to visualize the collected traces

- Verification of robot-shop application traces
![Jaeger UI Traces](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-2.png)

![Jaeger UI Traces](https://github.com/Andherson333333/robot-shop/blob/master/Infrastructure-cloud-EKS/infra-node/Jagger/imagenes/jagger-3.png)

The implemented architecture includes:
- **Jaeger Collector**: Receives traces from services instrumented by Istio
- **Jaeger Query**: Provides the user interface and APIs for querying traces
- **Jaeger Agent**: Included in All-in-One, local buffer for traces
- **Badger Storage**: Embedded database for trace persistence
- **Istio Proxy (Envoy)**: Automatically injects trace information into requests

## Maintenance
- The deployment is configured to run on infrastructure nodes with specific labels:
  - `node-type: infrastructure`
  - `workload-type: platform`
- Tolerations are applied to ensure proper scheduling
- Resource limits are established to ensure stable performance

---
For more information about Jaeger, see the [official Jaeger documentation](https://www.jaegertracing.io/docs/latest/).
