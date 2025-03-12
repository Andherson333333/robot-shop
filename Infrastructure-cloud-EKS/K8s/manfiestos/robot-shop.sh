#!/bin/bash

# Create namespace.yaml
cat << 'EOF' > namespace.yaml
# Crear namespace
apiVersion: v1
kind: Namespace
metadata:
  name: robot-shop
  labels:
    istio-injection: enabled
EOF

# Create configmaps
cat << 'EOF' > mysql-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: robot-shop
data:
  MYSQL_DATABASE: "cities"
  MYSQL_USER: "shipping"
EOF

cat << 'EOF' > shipping-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: shipping-config
  namespace: robot-shop
data:
  SPRING_DATASOURCE_URL: "jdbc:mysql://mysql:3306/cities?useSSL=false&allowPublicKeyRetrieval=true"
  SPRING_DATASOURCE_USERNAME: "shipping"
EOF

cat << 'EOF' > ratings-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ratings-config
  namespace: robot-shop
data:
  APP_ENV: "prod"
  MYSQL_HOST: "mysql"
  MYSQL_USERNAME: "ratings"
  MYSQL_DATABASE: "ratings"
EOF

cat << 'EOF' > web-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
  namespace: robot-shop
data:
  CATALOGUE_HOST: "catalogue"
  USER_HOST: "user"
  CART_HOST: "cart"
  SHIPPING_HOST: "shipping"
  PAYMENT_HOST: "payment"
  RATINGS_HOST: "ratings"
#  DISPATCH_HOST: "dispatch"
EOF

# Create secrets
cat << 'EOF' > mysql-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secrets
  namespace: robot-shop
type: Opaque
stringData:
  MYSQL_PASSWORD: "secret"
EOF

cat << 'EOF' > shipping-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: shipping-secrets
  namespace: robot-shop
type: Opaque
stringData:
  SPRING_DATASOURCE_PASSWORD: "secret"
EOF

cat << 'EOF' > ratings-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: ratings-secrets
  namespace: robot-shop
type: Opaque
stringData:
  MYSQL_PASSWORD: "iloveit"
EOF

# Create MongoDB resources
cat << 'EOF' > mongodb-service.yaml
# Servicio Headless para MongoDB
apiVersion: v1
kind: Service
metadata:
  name: mongodb-headless
  namespace: robot-shop
spec:
  clusterIP: None
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
---
# Servicio normal para MongoDB
apiVersion: v1
kind: Service
metadata:
  name: mongodb
  namespace: robot-shop
spec:
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
  type: ClusterIP
EOF

cat << 'EOF' > mongodb-statefulset.yaml
# StatefulSet MongoDB
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: robot-shop
  labels:
    app: mongodb
spec:
  serviceName: mongodb-headless
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: mongodb
        image: andherson1039/rs-mongodb
        ports:
        - containerPort: 27017
        livenessProbe:
         tcpSocket:
           port: 27017
         initialDelaySeconds: 30
         periodSeconds: 10
         timeoutSeconds: 5
         failureThreshold: 3
        readinessProbe:
         tcpSocket:
           port: 27017
         initialDelaySeconds: 10
         periodSeconds: 10
#        resources:
#          requests:
#            cpu: "200m"
#            memory: "512Mi"
#          limits:
#            cpu: "400m"
#            memory: "1Gi"
        volumeMounts:
        - name: mongodb-data
          mountPath: /data/db
  volumeClaimTemplates:
  - metadata:
      name: mongodb-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: gp3-default
      resources:
        requests:
          storage: 1Gi
EOF

cat << 'EOF' > mongodb-pv.yaml
# This file is a placeholder for MongoDB PV configuration
# The original YAML does not contain a specific PV definition for MongoDB
# It uses volumeClaimTemplates in the StatefulSet instead
EOF

# Create Redis resources
cat << 'EOF' > redis-deployment.yaml
# Redis Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: redis
        image: redis:alpine3.20
        ports:
        - containerPort: 6379
        livenessProbe:
         tcpSocket:
           port: 6379
         initialDelaySeconds: 15
         periodSeconds: 10
        readinessProbe:
         exec:
           command: ["redis-cli", "ping"]
         initialDelaySeconds: 5
         periodSeconds: 5
#       resources:
#         requests:
#            cpu: "100m"
#            memory: "128Mi"
#          limits:
#            cpu: "200m"
#            memory: "256Mi"
EOF

cat << 'EOF' > redis-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: robot-shop
spec:
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
  type: ClusterIP
EOF

# Create MySQL resources
cat << 'EOF' > mysql-service.yaml
# Servicio Headless para MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
  namespace: robot-shop
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
---
# Servicio normal para MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: robot-shop
spec:
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
  type: ClusterIP
EOF

cat << 'EOF' > mysql-statefulset.yaml
# StatefulSet MySQL
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: robot-shop
spec:
  serviceName: mysql-headless
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: mysql
        image: andherson1039/rs-mysql-db
        envFrom:
        - configMapRef:
            name: mysql-config
        - secretRef:
            name: mysql-secrets
        env:
        - name: MYSQL_ALLOW_EMPTY_PASSWORD
          value: "yes"
        ports:
        - containerPort: 3306
        livenessProbe:
          exec:
            command: ["mysqladmin", "ping"]
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command: ["mysql", "-h", "127.0.0.1", "-e", "SELECT 1"]
          initialDelaySeconds: 10
          periodSeconds: 10
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
          subPath: mysql-data
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: gp3-default
      resources:
        requests:
          storage: 1Gi
EOF

cat << 'EOF' > mysql-pv.yaml
# This file is a placeholder for MySQL PV configuration
# The original YAML does not contain a specific PV definition for MySQL
# It uses volumeClaimTemplates in the StatefulSet instead
EOF

# Create RabbitMQ resources
cat << 'EOF' > rabbitmq-deployment.yaml
# RabbitMQ Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rabbitmq
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: rabbitmq
  template:
    metadata:
      labels:
        app: rabbitmq
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: rabbitmq
        image: rabbitmq:4.0.3-management-alpine
        ports:
        - containerPort: 5672
        - containerPort: 15672
        livenessProbe:
         tcpSocket:
           port: 5672
         initialDelaySeconds: 60
         timeoutSeconds: 5
         periodSeconds: 10
        readinessProbe:
         exec:
           command: ["rabbitmq-diagnostics", "check_port_connectivity"]
         initialDelaySeconds: 60
         periodSeconds: 30
         timeoutSeconds: 10
         failureThreshold: 3
#        resources:
#          requests:
#            cpu: "200m"
#            memory: "256Mi"
#          limits:
#            cpu: "400m"
#            memory: "512Mi"
EOF

cat << 'EOF' > rabbitmq-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: rabbitmq
  namespace: robot-shop
spec:
  selector:
    app: rabbitmq
  ports:
  - name: amqp
    port: 5672
    targetPort: 5672
  - name: management
    port: 15672
    targetPort: 15672
  type: ClusterIP
EOF

# Create Catalogue resources
cat << 'EOF' > catalogue-deployment.yaml
# Catalogue Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalogue
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: catalogue
  template:
    metadata:
      labels:
        app: catalogue
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: catalogue
        image: andherson1039/rs-catalogue
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
EOF

cat << 'EOF' > catalogue-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: catalogue
  namespace: robot-shop
spec:
  selector:
    app: catalogue
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > catalogue-hpa.yaml
# HPA para Catalogue
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: catalogue-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: catalogue
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create User resources
cat << 'EOF' > user-deployment.yaml
# User Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: user
  template:
    metadata:
      labels:
        app: user
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: user
        image: andherson1039/rs-user
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "150m"
            memory: "240Mi"
EOF

cat << 'EOF' > user-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: user
  namespace: robot-shop
spec:
  selector:
    app: user
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > user-hpa.yaml
# HPA para User
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: user-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: user
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create Cart resources
cat << 'EOF' > cart-deployment.yaml
# Cart Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cart
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cart
  template:
    metadata:
      labels:
        app: cart
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: cart
        image: andherson1039/rs-cart
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
EOF

cat << 'EOF' > cart-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: cart
  namespace: robot-shop
spec:
  selector:
    app: cart
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > cart-hpa.yaml
# HPA para Cart
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cart-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cart
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create Shipping resources
cat << 'EOF' > shipping-deployment.yaml
# Shipping Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: shipping
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shipping
  template:
    metadata:
      labels:
        app: shipping
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      initContainers:
      - name: wait-for-mysql
        image: busybox
        command: ['sh', '-c', 'until nc -z mysql 3306; do echo waiting for mysql; sleep 2; done;']
      containers:
      - name: shipping
        image: andherson1039/rs-shipping
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        envFrom:
        - configMapRef:
            name: shipping-config
        - secretRef:
            name: shipping-secrets
        resources:
          requests:
            cpu: "400m"
            memory: "600Mi"
          limits:
            cpu: "600m"
            memory: "1Gi"
EOF

cat << 'EOF' > shipping-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: shipping
  namespace: robot-shop
spec:
  selector:
    app: shipping
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > shipping-hpa.yaml
# HPA para Shipping
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: shipping-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: shipping
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
EOF

# Create Payment resources
cat << 'EOF' > payment-deployment.yaml
# Payment Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payment
  template:
    metadata:
      labels:
        app: payment
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: payment
        image: andherson1039/rs-payment:latest
        ports:
        - containerPort: 8080
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        resources:
          requests:
            cpu: "50m"
            memory: "128Mi"
          limits:
            cpu: "100m"
            memory: "256Mi"
EOF

cat << 'EOF' > payment-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: payment
  namespace: robot-shop
spec:
  selector:
    app: payment
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > payment-hpa.yaml
# HPA para Payment
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: payment-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: payment
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create Dispatch resources
cat << 'EOF' > dispatch-deployment.yaml
# Dispatch Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dispatch
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dispatch
  template:
    metadata:
      labels:
        app: dispatch
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: dispatch
        image: andherson1039/rs-dispatch
        ports:
        - containerPort: 8080
       # livenessProbe:
       #   exec:
       #     command:
       #     - pgrep
       #     - "dispatch"
       #   initialDelaySeconds: 60
       #   periodSeconds: 30
       #   timeoutSeconds: 10
       #   failureThreshold: 6
       # readinessProbe:
       #   exec:
       #     command:
       #     - /bin/sh
       #     - -c
       #     - 'nc -z localhost 8080'
       #   initialDelaySeconds: 40
       #   periodSeconds: 20
       #   timeoutSeconds: 5
       #   failureThreshold: 4
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
EOF

cat << 'EOF' > dispatch-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: dispatch
  namespace: robot-shop
spec:
  selector:
    app: dispatch
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > dispatch-hpa.yaml
# HPA para Dispatch
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: dispatch-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: dispatch
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create Ratings resources
cat << 'EOF' > ratings-deployment.yaml
# Ratings Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
 name: ratings
 namespace: robot-shop
spec:
 replicas: 1
 selector:
   matchLabels:
     app: ratings
 template:
   metadata:
     labels:
       app: ratings
   spec:
     # Configuración para ejecutar en nodos de aplicación
     nodeSelector:
       node-type: application
       workload-type: business
     containers:
     - name: ratings
       image: andherson1039/rs-ratings:latest
       ports:
       - containerPort: 80
       livenessProbe:
         tcpSocket:
           port: 80
         initialDelaySeconds: 60
         periodSeconds: 20
         timeoutSeconds: 5
         failureThreshold: 5
       readinessProbe:
         tcpSocket:
           port: 80
         initialDelaySeconds: 30
         periodSeconds: 10
         timeoutSeconds: 3
         failureThreshold: 3
       envFrom:
       - configMapRef:
           name: ratings-config
       - secretRef:
           name: ratings-secrets
       resources:
         requests:
           cpu: "50m"
           memory: "64Mi"
         limits:
           cpu: "100m"
           memory: "128Mi"
EOF

cat << 'EOF' > ratings-service.yaml
apiVersion: v1
kind: Service
metadata:
 name: ratings
 namespace: robot-shop
spec:
 selector:
   app: ratings
 ports:
 - port: 8080
   targetPort: 80
 type: ClusterIP
EOF

cat << 'EOF' > ratings-hpa.yaml
# HPA para Ratings
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ratings-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ratings
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Create Web resources
cat << 'EOF' > web-deployment.yaml
# Web Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: robot-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      # Configuración para ejecutar en nodos de aplicación
      nodeSelector:
        node-type: application
        workload-type: business
      containers:
      - name: web
        image: andherson1039/rs-web:latest
        ports:
        - containerPort: 8080
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 2
        envFrom:
        - configMapRef:
            name: web-config
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
EOF

cat << 'EOF' > web-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: robot-shop
spec:
  selector:
    app: web
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
EOF

cat << 'EOF' > web-hpa.yaml
# HPA para Web
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
  namespace: robot-shop
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF

cat << 'EOF' > web-ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: robot-shop
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
spec:
  ingressClassName: nginx-external
  tls:
  - hosts:
    - robotshop.andherson33.click
  rules:
  - host: robotshop.andherson33.click
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 8080
EOF

echo "All Kubernetes YAML files have been created successfully."
