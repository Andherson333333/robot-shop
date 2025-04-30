> Spanish version of this README is available as ReadmeES.md

# Load Testing Configurations for Robot Shop
This repository contains various load testing configurations for the Robot Shop microservices application using Kubernetes Jobs. The tests use both Fortio and curl to generate different load patterns.

## General Description
The load testing suite includes multiple configurations to evaluate different components of the Robot Shop application:
- TCP-based load tests with different intensities
- HTTP endpoint tests
- Continuous service monitoring
- Specific product endpoint tests

## Available Configurations
### 1. High Load Test (loadtestCarga.yaml)
A comprehensive load test targeting multiple services with different intensities:
- Web Service: 20 QPS with 10 concurrent connections
- Catalog Service: 50 QPS with 15 concurrent connections
- Cart Service: 30 QPS with 8 concurrent connections
- User Service: 15 QPS with 5 concurrent connections
- Shipping Service: 10 QPS with 3 concurrent connections
- Payment Service: 25 QPS with 12 concurrent connections

All containers are limited in resources with:
- CPU: 100m (request) / 200m (limit)
- Memory: 128Mi (request) / 256Mi (limit)

### 2. Basic TCP Load Test (loadtestTCP.yaml)
A lighter load test configuration with uniform parameters across all services:
- 5 QPS
- 2 concurrent connections
- Duration of 30 seconds
- Tests the web, catalog, cart, user, shipping, and payment services

### 3. HTTP Endpoints Test (loadtHTTP.yaml)
Focused on testing specific HTTP endpoints:
- External web access tests
- Tests for specific product endpoints: RED, EMM, SHCE
- Includes detailed logging with curl verbose mode

### 4. Service Monitoring (loadtestError.yaml)
Continuous monitoring of all service endpoints with:
- Regular polling of all services
- 0.5 second interval between test cycles
- Monitors the web, catalog, cart, user, shipping, payment, ratings, and dispatch services
