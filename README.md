--------------------------   English  ------------------------------------
# AWS GitOps Pipeline: Automated Container Deployment with Terraform Cloud

## 🎯 Overview
This project implements a fully automated CI/CD pipeline for deploying a containerized Nginx web server on AWS. It leverages **Infrastructure as Code (IaC)** and **GitOps** principles to ensure repeatable and secure deployments.

## 🏗️ Architecture: (assets/architecture-diagram.png)

### Key Components:
- **CI/CD:** [GitHub Actions](https://github.com) for automation.
- **IaC:** [Terraform Cloud](https://hashicorp.com) (Remote Backend) for state management.
- **Compute:** [Amazon EC2](https://amazon.com) running **Amazon Linux 2023**.
- **Registry:** [Amazon ECR](https://amazon.com) for private Docker image storage.
- **Security:** [AWS IAM Roles](https://amazon.com) with Least Privilege principle and [AWS Systems Manager (SSM)](https://amazon.com) for secure instance management.

## 🚀 Engineering Highlights

### 1. Zero-Secrets Workflow
Instead of using long-lived AWS Access Keys, this pipeline uses **OpenID Connect (OIDC)** (or secure TFC variables) to authenticate GitHub Actions with AWS, significantly reducing the attack surface.

### 2. Automated Provisioning (User Data)
The EC2 instance is completely "self-healing". Upon launch, it executes a [User Data script](https://amazon.com) that:
- Installs Docker.
- Authenticates with Amazon ECR.
- Pulls the latest production image.
- Runs the container on port 80.

### 3. Modern OS: Amazon Linux 2023
Selected for its improved security posture, faster boot times, and optimized AWS integration compared to legacy versions.

## 🛠️ How to Deploy
1. **Prerequisites:** AWS Account, Terraform Cloud account, and GitHub repo.
2. **Setup:** Configure your TFC workspace with AWS credentials.
3. **Execution:** Push a change to the `main` branch. GitHub Actions will trigger the Terraform plan/apply.

## 📈 Roadmap (Next Steps)
- [ ] Implement an **Application Load Balancer (ALB)** for High Availability.
- [ ] Migrate to **Private Subnets** using VPC Endpoints for ECR.
- [ ] Centralize logs using **Amazon CloudWatch**.


---------------------------- Spanish -------------------------------------------------------

# Pipeline GitOps de AWS: Despliegue automatizado de contenedores con Terraform Cloud

## 🎯 Descripción general
Este proyecto implementa un pipeline de CI/CD totalmente automatizado para desplegar un servidor web Nginx en contenedores en AWS. Aprovecha los principios de **Infraestructura como Código (IaC)** y **GitOps** para garantizar despliegues repetibles y seguros.

## 🏗️ Arquitectura: (assets/architecture-diagram.png)

### Componentes clave:

- **CI/CD:** [GitHub Actions](https://github.com) para la automatización.
- **IaC:** [Terraform Cloud](https://hashicorp.com) (Backend remoto) para la gestión del estado.
- **Computación:** [Amazon EC2](https://amazon.com) con **Amazon Linux 2023**.
- **Registro:** [Amazon ECR](https://amazon.com) para el almacenamiento privado de imágenes Docker.
- **Seguridad:** [Roles de AWS IAM](https://amazon.com) con el principio de mínimo privilegio y [AWS Systems Manager (SSM)](https://amazon.com) para la administración segura de instancias.

## 🚀 Aspectos destacados de ingeniería

### 1. Flujo de trabajo sin secretos
En lugar de usar claves de acceso de AWS de larga duración, este flujo de trabajo utiliza **OpenID Connect (OIDC)** (o variables TFC seguras) para autenticar GitHub Actions con AWS, lo que reduce significativamente la superficie de ataque.

### 2. Aprovisionamiento automatizado (datos de usuario)
La instancia EC2 es completamente autorreparable. Al iniciarse, ejecuta un [script de datos de usuario](https://amazon.com) que:
- Instala Docker.
- Se autentica con Amazon ECR.
- Descarga la última imagen de producción.
- Ejecuta el contenedor en el puerto 80.

### 3. Sistema operativo moderno: Amazon Linux 2023
Seleccionado por su seguridad mejorada, tiempos de arranque más rápidos e integración optimizada con AWS en comparación con las versiones anteriores.

## 🛠️ Cómo implementar

1. **Requisitos previos:** Cuenta de AWS, cuenta de Terraform Cloud y repositorio de GitHub.
2. **Configuración:** Configura tu espacio de trabajo de TFC con las credenciales de AWS.
3. **Ejecución:** Envía un cambio a la rama `main`. GitHub Actions activará el plan/apply de Terraform.

## 📈 Hoja de ruta (Próximos pasos)
- [ ] Implementar un **Balanceador de carga de aplicaciones (ALB)** para alta disponibilidad.
- [ ] Migrar a **Subredes privadas** usando puntos finales de VPC para ECR.
- [ ] Centralizar los registros usando **Amazon CloudWatch**.
