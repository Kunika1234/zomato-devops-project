# 🎓 Zomato DevSecOps Clone: Viva Q&A Guide

Prepare these questions and answers to score maximum marks in your project viva.

---

## 💻 Section 1: DevOps & CI/CD Pipeline Questions

### Q1: What is the difference between DevOps and DevSecOps?
* **Answer**: DevOps integrates Software Development (Dev) and IT Operations (Ops) to shorten the development lifecycle and deliver high-quality software continuously. **DevSecOps** goes a step further by integrating security audits and vulnerability checks *automatically* into every stage of the CI/CD pipeline, rather than treating security as an afterthought.

### Q2: What are the stages in your Jenkins pipeline, and why are they placed in that order?
* **Answer**: 
  1. **Git Checkout**: Pull code.
  2. **SonarQube Analysis**: SAST (Static Code Quality/Security check) before compilation.
  3. **Install Dependencies**: Resolve packages needed for building/scanning.
  4. **OWASP Dependency Check**: SCA (Software Composition Analysis) to scan third-party packages for vulnerabilities.
  5. **Trivy FS Scan**: File system scan to detect exposed credentials/keys.
  6. **Build & Push Image**: Create production Docker image and push to Nexus.
  7. **Trivy Image Scan**: Scan built Docker container image layers.
  8. **Deploy Container**: Launch the updated app.
  * *Ordering Rationale*: We scan code quality (SonarQube) and dependency safety (OWASP, Trivy FS) *before* building the final Docker container to ensure we do not build or push insecure code into our Nexus registry.

### Q3: Why do we use a private Registry like Sonatype Nexus instead of Docker Hub?
* **Answer**: In corporate environments, proprietary code/images cannot be pushed to public registries (like Docker Hub) for compliance, intellectual property, and security reasons. Nexus hosts our **private, internal Docker registry** behind our firewall where images can be stored securely.

---

## 🛡️ Section 2: Security & Scanning Tools

### Q4: What is SAST, and how did you implement it?
* **Answer**: SAST stands for **Static Application Security Testing**. It inspects the application's source code without running it to find security gaps, bugs, and code smells. We implemented this using **SonarQube** in Stage 2 of our pipeline.

### Q5: What is SCA, and how did you check for third-party vulnerabilities?
* **Answer**: SCA stands for **Software Composition Analysis**. It identifies open-source/third-party dependencies in the project and alerts us to known CVEs (Common Vulnerabilities and Exposures). We used **OWASP Dependency Check** (evaluating `package.json` libraries) to implement SCA.

### Q6: What is Trivy, and what does it scan in your project?
* **Answer**: Trivy is a highly efficient vulnerability and misconfiguration scanner. In our pipeline, Trivy performs two roles:
  1. **FS Scan**: Scans source files for leaked API keys, configuration errors, and hardcoded credentials.
  2. **Image Scan**: Scans OS packages (Alpine library layers) and dependencies inside the compiled production Docker image to ensure the container itself is secure.

---

## 🐳 Section 3: Containerization & Reverse Proxy

### Q7: Why do you use Nginx in this project?
* **Answer**: Nginx acts as a **Reverse Proxy & API Gateway**. Instead of exposing random ports for Jenkins (8080), SonarQube (9000), Nexus (8081), and Grafana (3000), Nginx serves everything on a single standard HTTP Port (80) under subpaths (`/jenkins`, `/sonarqube`, `/nexus`, `/grafana`), providing a single entry point and enhancing system security.

### Q8: What does `depends_on` do in `docker-compose.yml`?
* **Answer**: It specifies startup dependencies between containers. For example, SonarQube requires the PostgreSQL database (`db`) to be healthy before starting up.

---

## 📊 Section 4: Monitoring & Observability

### Q9: Explain the Prometheus & Grafana architecture in your system.
* **Answer**: 
  * **Prometheus** is a time-series database that actively pulls (scrapes) metrics from exporters (like `Node Exporter` for host metrics and `cAdvisor` for Docker container metrics) at regular intervals.
  * **Grafana** connects to Prometheus as a data source and visualizes those metric trends on customizable dashboard interfaces (like CPU load, memory utilization, and network traffic).

### Q10: What are Loki and Promtail used for?
* **Answer**: 
  * **Loki** is a log aggregation system designed by Grafana (referred to as "like Prometheus, but for logs").
  * **Promtail** is the agent that runs on the host, scrapes logs from Docker container outputs (stored in `/var/lib/docker/containers`), and ships them to Loki. We can then view these logs in Grafana.
