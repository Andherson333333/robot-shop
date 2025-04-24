> Spanish version of this README is available as ReadmeES.md

# CI/CD Workflows for Robot Shop
This repository contains the Continuous Integration (CI) workflows for the Robot Shop microservices application. Each service has its own CI pipeline implemented using GitHub Actions.

## General Description
The CI workflows are designed to automate the build, test, and deployment processes for the following services:
- Cart Service (Node.js)
- Catalogue Service (Node.js)
- Dispatch Service (Go)
- Payment Service (Python)
- Shipping Service (Java)
- User Service (Node.js)
- Web Service (Static Files)

![structure](https://github.com/Andherson333333/robot-shop/blob/master/.github/imagenes/cd-2.png)

![structure](https://github.com/Andherson333333/robot-shop/blob/master/.github/imagenes/cd-1.png)

## Common Features
All workflows include:
- **Automatic Workflow Cancellation**: Cancels redundant runs to optimize CI resources
- **SonarCloud Integration**: Code quality and security analysis
- **Docker Image Building**: Automated building and pushing to Docker Hub
- **Kubernetes Manifest Updates**: Automatic update of deployment files with new image tags
- **Production Mode Control**: `PRODUCTION_MODE` environment variable to control error handling

## Production vs. Development Mode
The `PRODUCTION_MODE` environment variable controls how workflows behave when encountering errors:

- **Development Mode (PRODUCTION_MODE=false)**:
  - Workflow steps continue executing even if errors occur
  - Ideal for development and testing where we want to see all potential issues
  - Does not fail the entire pipeline on minor or expected errors
  - Allows incremental corrections

- **Production Mode (PRODUCTION_MODE=true)**:
  - Steps fail immediately when they encounter an error
  - The entire pipeline stops when a problem is detected
  - Ensures greater rigor in code quality
  - Appropriate for production environments where deployments with failures should not be allowed

To switch between modes, simply modify the value of the `PRODUCTION_MODE` variable in the workflow file.

## Requirements
To use these workflows, you need to configure the following secrets:
- DOCKER_USERNAME: Docker Hub username
- DOCKER_PASSWORD: Docker Hub password
- SONAR_TOKEN: SonarCloud authentication token
- GITHUB_TOKEN: Automatically provided by GitHub

## Service-Specific Configurations
### Node.js Services (Cart, Catalogue, User)
- Node.js v18 environment
- NPM dependency installation
- Security audits and fixes
- Test execution (when available)

### Go Service (Dispatch)
- Go v1.22 environment
- Go module initialization and dependency management
- Analysis with Go vet
- Vulnerability check with govulncheck

### Python Service (Payments)
- Python 3.9 environment
- Dependency management with pip
- Testing with pytest
- Security scanning with Bandit

### Java Service (Shipping)
- JDK 8
- Maven build system
- Dependency resolution
- Package building and testing

### Web Service
- Static file verification
- Entry script permission management
- Nginx-based deployment

## Workflow Triggers
Workflows are triggered by:
- Push events to main/master branches (path-specific)
- Pull requests to main/master branches (path-specific)
- Manual workflow execution

## Deployment Environments
The workflows automatically update Kubernetes manifests for two environments:
- **On-Premises Infrastructure**: `Infrastructure-onprem/K8s/manifiestos/`
- **Cloud Infrastructure (EKS)**: `Infrastructure-cloud-EKS/infra-aplicacion/K8s/manfiestos/`

## Development Notes
- All workflows use continue-on-error based on the PRODUCTION_MODE variable
- Image tags are based on the GitHub commit SHA
- Automatic commits update K8s deployment files
- Each service's CI is isolated to its specific directory
