# 🍽️ Zomato Clone: Secure Deployment with DevSecOps CI/CD

## 📌 Project Overview
This project is a full-stack **Zomato Clone** food-delivery web application integrated with a state-of-the-art **DevSecOps CI/CD pipeline**. It represents a modern enterprise-grade deployment workflow focusing on automation, security scanning (DevSecOps), continuous delivery, and comprehensive system monitoring.

---

## 🛠️ Architecture & Tech Stack

```mermaid
graph TD
    User([User Browser]) -->|HTTP Port 80| Nginx[Nginx Reverse Proxy Gateway]
    Nginx -->|Route: /| ReactApp[React.js Frontend Container]
    Nginx -->|Route: /jenkins| Jenkins[Jenkins CI/CD Automation Server]
    Nginx -->|Route: /sonarqube| SonarQube[SonarQube Code Quality Analysis]
    Nginx -->|Route: /nexus| Nexus[Nexus Artifact & Docker Registry]
    Nginx -->|Route: /prometheus| Prometheus[Prometheus Metrics Storage]
    Nginx -->|Route: /grafana| Grafana[Grafana Dashboard Visualization]
    
    Jenkins -->|1. Pull Code| Git[Git Workspace]
    Jenkins -->|2. Analysis| SonarQube
    Jenkins -->|3. Security Scanning| Trivy[Trivy File System & Image Scanner]
    Jenkins -->|4. Vulnerability Check| OWASP[OWASP Dependency Check]
    Jenkins -->|5. Store Artifacts| Nexus
    Jenkins -->|6. Deploy container| ReactApp
    
    Prometheus -->|Scrape Metrics| ReactApp
    Prometheus -->|Scrape Metrics| NodeExporter[Node Exporter Host Metrics]
    Prometheus -->|Scrape Metrics| cAdvisor[cAdvisor Container Metrics]
    
    Loki[Loki Log Storage] <-- Promtail[Promtail Log Collector]
    Promtail -->|Tail Logs| ReactApp
    Promtail -->|Tail Logs| Jenkins
    Grafana -->|Query Metrics| Prometheus
    Grafana -->|Query Logs| Loki
```

### 1. Frontend Application
* **React.js**: Standard UI library providing a rich, responsive interface with menu views, cart additions, checkouts, and order tracking.
* **Sass/SCSS**: Modular, structured styling.

### 2. DevSecOps CI/CD Pipeline (Jenkinsfile)
The pipeline automates steps from code commit to deployment with security verification at every gate:
* **Stage 1: Git Checkout** - Pulls the latest source code.
* **Stage 2: SonarQube Analysis** - Static application security testing (SAST) and code quality analysis.
* **Stage 3: Dependency Resolution** - Resolves npm packages inside isolated clean containers.
* **Stage 4: OWASP Dependency Check** - Software Composition Analysis (SCA) to flag vulnerable third-party libraries.
* **Stage 5: Trivy File System Scan** - Scans the project files for keys, secrets, or configuration errors.
* **Stage 6: Build & Push Image** - Builds a production Docker image and pushes it to our local private **Nexus Docker registry**.
* **Stage 7: Trivy Image Scan** - Scans the final built production image to ensure no system vulnerabilities are inside.
* **Stage 8: Deploy Container** - Automatically replaces the running container with the new verified secure version.

### 3. Monitoring & Observability Stack
* **Prometheus**: Collects system metrics from the host machine (via Node Exporter) and running containers (via cAdvisor).
* **Loki & Promtail**: Collects logs from all docker containers and streams them to Loki.
* **Grafana**: Beautiful dashboards visualizing CPU, memory, system logs, and DevOps stack status in real-time.

### 4. Gateway Integration
* **Nginx**: Serves as a Reverse Proxy Gateway routing users to the React application, Jenkins, SonarQube, Nexus, and Grafana under a single domain/IP (e.g., http://localhost).
