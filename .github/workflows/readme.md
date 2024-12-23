# Flujos de CI/CD para Robot Shop

Este repositorio contiene los flujos de trabajo de Integración Continua (CI) para la aplicación de microservicios Robot Shop. Cada servicio tiene su propio pipeline de CI implementado usando GitHub Actions.

## Descripción General

Los flujos de trabajo de CI están diseñados para automatizar los procesos de construcción, pruebas y despliegue para los siguientes servicios:
- Servicio de Carrito (Node.js)
- Servicio de Catálogo (Node.js) 
- Servicio de Despacho (Go)
- Servicio de Pagos (Python)
- Servicio de Envíos (Java)
- Servicio de Usuarios (Node.js)
- Servicio Web (Archivos Estáticos)

## Características Comunes

Todos los flujos de trabajo incluyen:

- **Cancelación Automática de Flujos**: Cancela ejecuciones redundantes para optimizar recursos de CI
- **Integración con SonarCloud**: Análisis de calidad y seguridad del código
- **Construcción de Imágenes Docker**: Construcción automatizada y envío a Docker Hub 
- **Actualización de Manifiestos Kubernetes**: Actualización automática de archivos de despliegue con nuevas etiquetas de imagen
- **Control de Modo Producción**: Variable de entorno `PRODUCTION_MODE` para controlar el manejo de errores

## Requisitos 

Para usar estos flujos, necesitas configurar los siguientes secretos:

- DOCKER_USERNAME: Usuario de Docker Hub
- DOCKER_PASSWORD: Contraseña de Docker Hub
- SONAR_TOKEN: Token de autenticación de SonarCloud
- GITHUB_TOKEN: Proporcionado automáticamente por GitHub


## Configuraciones Específicas por Servicio

### Servicios Node.js (Carrito, Catálogo, Usuario)
- Entorno Node.js v18
- Instalación de dependencias NPM
- Auditoría de seguridad y correcciones
- Ejecución de pruebas (cuando están disponibles)

### Servicio Go (Despacho)
- Entorno Go v1.22
- Inicialización de módulos Go y gestión de dependencias
- Análisis con Go vet
- Verificación de vulnerabilidades con govulncheck

### Servicio Python (Pagos)
- Entorno Python 3.9
- Gestión de dependencias con pip
- Pruebas con pytest
- Escaneo de seguridad con Bandit

### Servicio Java (Envíos)
- JDK 8
- Sistema de construcción Maven
- Resolución de dependencias
- Construcción de paquetes y pruebas

### Servicio Web
- Verificación de archivos estáticos
- Gestión de permisos de script de entrada
- Despliegue basado en Nginx

## Activadores del Flujo de Trabajo

Los flujos se activan por:
- Eventos push a las ramas main/master (específicos por ruta)
- Pull requests hacia las ramas main/master (específicos por ruta)
- Ejecución manual del flujo de trabajo

## Notas de Desarrollo

- Todos los flujos usan continue-on-error basado en la variable PRODUCTION_MODE
- Las etiquetas de imagen se basan en el SHA del commit de GitHub
- Los commits automáticos actualizan archivos de despliegue K8s
- El CI de cada servicio está aislado a su directorio específico

