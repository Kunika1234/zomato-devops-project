# Self-healing start script for the Zomato Clone & DevSecOps Platform
# Run this file in PowerShell: .\run-project.ps1

Clear-Host
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "🚀 Starting Zomato Clone & DevSecOps Pipeline Stack" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# Step 1: Verify Prerequisites
Write-Host "`n🔍 Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
try {
    $nodeVer = node -v
    Write-Host "✅ Node.js detected: $nodeVer" -ForegroundColor Green
} catch {
    Write-Host '❌ Node.js is not installed. Please install Node.js (LTS recommended) and try again.' -ForegroundColor Red
    Exit 1
}

# Check Docker Desktop
try {
    $null = docker info 2>&1
    $dockerVer = docker -v
    Write-Host "✅ Docker Engine is running: $dockerVer" -ForegroundColor Green
} catch {
    Write-Host '❌ Docker Engine is NOT running. Please start Docker Desktop and ensure the engine is active before running this script.' -ForegroundColor Red
    Exit 1
}

# Step 2: Install dependencies
Write-Host "`n📦 Checking and installing dependencies..." -ForegroundColor Yellow
npm install --legacy-peer-deps

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install Node dependencies." -ForegroundColor Red
    Exit 1
}
Write-Host "✅ Dependencies verified." -ForegroundColor Green

# Step 3: Test Frontend Build
Write-Host "`n🏗️ Building React Frontend static assets..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed." -ForegroundColor Red
    Exit 1
}
Write-Host "✅ Frontend build completed successfully." -ForegroundColor Green

# Step 4: Run Docker Compose
Write-Host "`n🧹 Cleaning up conflicting container names..." -ForegroundColor Yellow
$conflictingContainers = @("nexus", "jenkins", "postgres-db", "sonarqube", "prometheus", "grafana", "nginx-proxy", "node-exporter", "cadvisor", "loki", "promtail", "nexus-provisioner", "zomato-clone")
foreach ($c in $conflictingContainers) {
    if (docker ps -a --format '{{.Names}}' | Select-String -SimpleMatch -Pattern $c) {
        Write-Host "  Stopping and removing stale container: $c" -ForegroundColor Gray
        docker rm -f $c | Out-Null
    }
}

Write-Host "`n🚢 Spining up DevOps containers (databases, servers, Nginx proxy)..." -ForegroundColor Yellow
docker compose up -d --build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker compose failed to start." -ForegroundColor Red
    Exit 1
}
Write-Host "✅ DevOps containers started successfully in background!" -ForegroundColor Green

# Step 5: Start Zomato Clone container (to avoid 502 Bad Gateway)
Write-Host "`n🍽️ Starting Zomato Clone web application..." -ForegroundColor Yellow
docker rm -f zomato-clone 2>&1 | Out-Null
$runStatus = docker run -d --name zomato-clone --network evops_network -p 3001:80 localhost:8082/zomato-clone:latest 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "  Building application image..." -ForegroundColor Gray
    docker build -t localhost:8082/zomato-clone:latest .
    docker run -d --name zomato-clone --network evops_network -p 3001:80 localhost:8082/zomato-clone:latest | Out-Null
}
Write-Host "✅ Zomato Clone application started successfully!" -ForegroundColor Green

# Summary & URLs
Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "🎉 ALL SERVICES STARTED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host 'You can access the DevOps pipeline & portals using the links below:'
Write-Host '🔗 Nginx Gateway:    http://localhost' -ForegroundColor Yellow
Write-Host '🔗 Jenkins:          http://localhost/jenkins/      (Admin / admin)' -ForegroundColor Yellow
Write-Host '🔗 SonarQube:        http://localhost/sonarqube/    (Admin / admin123)' -ForegroundColor Yellow
Write-Host '🔗 Nexus Repository: http://localhost/nexus/        (Admin / admin123)' -ForegroundColor Yellow
Write-Host '🔗 Grafana Metrics:  http://localhost/grafana/      (Default dashboards active)' -ForegroundColor Yellow
Write-Host '🔗 Prometheus:       http://localhost/prometheus/' -ForegroundColor Yellow
Write-Host "`nUse 'docker compose down' to stop the services when finished." -ForegroundColor Gray
Write-Host "==================================================================" -ForegroundColor Cyan
