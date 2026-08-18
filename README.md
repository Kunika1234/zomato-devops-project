# 🍽️ Zomato Clone — DevSecOps & CI/CD Project

A full-stack Zomato-inspired food delivery application integrated with a **DevOps/DevSecOps pipeline** for automated build, containerization, deployment, security, monitoring, and logging.

## 🚀 Project Overview

This project demonstrates how a modern web application can be integrated with DevOps practices to create a more automated, secure, and observable deployment workflow.

The application is containerized using **Docker** and supported by a complete DevOps environment including **Jenkins, Prometheus, Grafana, Loki, Promtail, Nginx, and Docker Compose**.

## 🛠️ Technologies Used

| Category                     | Technologies               |
| ---------------------------- | -------------------------- |
| Frontend                     | React.js, JavaScript, SCSS |
| Version Control              | Git, GitHub                |
| Containerization             | Docker, Docker Compose     |
| CI/CD                        | Jenkins                    |
| Code Quality / Security      | SonarQube                  |
| Monitoring                   | Prometheus, Grafana        |
| Logging                      | Loki, Promtail             |
| Web Server / Reverse Proxy   | Nginx                      |
| Scripting                    | PowerShell, Batch, Shell   |
| Infrastructure Configuration | YAML                       |

## ✨ Key Features

* 🍔 Zomato-inspired food delivery interface
* 🐳 Docker-based application containerization
* 🔄 Jenkins-based CI/CD automation
* 🔍 SonarQube integration for code quality/security analysis
* 📊 Prometheus-based metrics collection
* 📈 Grafana dashboards for monitoring
* 📝 Loki and Promtail for centralized logging
* 🌐 Nginx configuration for web serving/reverse proxy
* 🧩 Docker Compose for managing multiple services
* 📁 Organized monitoring and infrastructure configuration
* 📜 Project documentation and DevOps viva questions

## 🔄 DevOps Pipeline

The project follows a DevOps workflow similar to:

```text
Developer
    ↓
Git / GitHub
    ↓
Jenkins CI/CD
    ↓
Code Quality & Security Analysis
    ↓
Docker Build
    ↓
Container Deployment
    ↓
Nginx
    ↓
Application
    ↓
Prometheus → Grafana
    ↓
Loki ← Promtail
```

## 🐳 Docker

The application and supporting services are configured using Docker.

The repository includes:

* `Dockerfile`
* `docker-compose.yml`
* Jenkins Docker configuration
* Supporting service configurations

To start the configured services:

```bash
docker compose up -d
```

To check running containers:

```bash
docker ps
```

To stop the services:

```bash
docker compose down
```

## 🔧 Jenkins CI/CD

Jenkins is used to automate the CI/CD workflow.

The repository contains:

```text
jenkinsfile
jenkins/
```

The pipeline can be used to automate stages such as:

```text
Checkout
   ↓
Build
   ↓
Code Quality / Security
   ↓
Docker Build
   ↓
Deployment
```

## 🔍 SonarQube

SonarQube is integrated into the DevOps environment to support:

* Static code analysis
* Code quality checks
* Identification of potential issues
* Security-oriented code analysis

## 📊 Monitoring with Prometheus & Grafana

Prometheus is configured for metrics collection and Grafana is used to visualize monitoring data.

The repository contains multiple Grafana dashboards, including:

* Application Dashboard
* CI/CD Dashboard
* Docker Dashboard
* Health Dashboard
* System Dashboard

Configuration files are available under:

```text
grafana/
prometheus/
```

## 📝 Centralized Logging

The project uses **Loki and Promtail** for log collection and centralized log management.

```text
Application / Containers
        ↓
     Promtail
        ↓
       Loki
        ↓
     Grafana
```

Configuration files:

```text
loki/
promtail/
```

## 🌐 Nginx

Nginx is included in the infrastructure configuration and can be used as a web server/reverse proxy in the deployment architecture.

Configuration:

```text
nginx/nginx.conf
```

## 📁 Project Structure

```text
zomato-devops-project/
│
├── grafana/
│   ├── dashboards/
│   └── provisioning/
│
├── jenkins/
│   ├── Dockerfile
│   └── jenkins.yaml
│
├── loki/
│   └── loki-config.yml
│
├── nginx/
│   └── nginx.conf
│
├── prometheus/
│   └── prometheus.yml
│
├── promtail/
│   └── promtail-config.yml
│
├── scripts/
│   ├── Dockerfile
│   └── init-nexus.sh
│
├── src/
│
├── Dockerfile
├── docker-compose.yml
├── jenkinsfile
├── package.json
├── PROJECT_EXPLANATION.md
├── VIVA_QUESTIONS.md
├── run-project.bat
├── run-project.ps1
└── README.md
```

## ⚙️ Running the Application

### Prerequisites

Install the following:

* Node.js
* npm
* Git
* Docker
* Docker Compose

Check Node.js and npm:

```bash
node -v
npm -v
```

### Install Dependencies

```bash
npm install
```

### Run Development Server

```bash
npm start
```

The application can then be accessed locally through the development server.

## 🐳 Run with Docker Compose

Start the configured environment:

```bash
docker compose up -d
```

Check services:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Stop the environment:

```bash
docker compose down
```

## 📚 Documentation

Additional project documentation is available in:

### Project Explanation

`PROJECT_EXPLANATION.md`

Contains detailed information about the project and its implementation.

### Viva Questions

`VIVA_QUESTIONS.md`

Contains questions and explanations useful for understanding and presenting the project.

## 🎯 Learning Objectives

This project was developed to gain practical understanding of:

* DevOps lifecycle
* CI/CD automation
* Docker containerization
* Jenkins pipelines
* Code quality and security analysis
* Infrastructure configuration
* Application monitoring
* Centralized logging
* Reverse proxy configuration
* Git and GitHub workflows

## 👩‍💻 Author

**Kunika Prajapat**

MCA | Aspiring DevOps / Cloud Engineer

GitHub: [Kunika1234](https://github.com/Kunika1234)

## ⭐ Project

If you find this project useful for learning DevOps and DevSecOps concepts, feel free to explore the repository.

---

**Built as a practical DevOps & DevSecOps learning project. 🚀**
