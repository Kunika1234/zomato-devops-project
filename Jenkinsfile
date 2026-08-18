pipeline {
    agent any

    environment {
        REGISTRY = 'localhost:8082'
        IMAGE_NAME = 'zomato-clone'
        SONAR_HOST = 'http://sonarqube:9000/sonarqube'
        WORKSPACE_PATH = '/var/jenkins_home/workspace/Zomato-Clone'
    }

    stages {
        // Stage 1: Git Checkout
        stage('Git Checkout') {
            steps {
                echo 'Stage 1: Checking out source code...'
                checkout scm
            }
        }

        // Stage 2: SonarQube Code Analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Stage 2: Executing static code quality analysis...'
                sh """
                docker run --rm -v jenkins_data:/var/jenkins_home -w ${WORKSPACE_PATH} --network evops_network \
                    sonarsource/sonar-scanner-cli:5.0 \
                    -Dsonar.projectKey=zomato-clone \
                    -Dsonar.projectName="Zomato Clone" \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_HOST} \
                    -Dsonar.login=admin \
                    -Dsonar.password=admin123
                """
            }
        }

        // Stage 3: NPM Dependency Install
        stage('Install Dependencies') {
            steps {
                echo 'Stage 3: Installing npm dependencies...'
                sh "docker run --rm -v jenkins_data:/var/jenkins_home -w ${WORKSPACE_PATH} node:18-alpine npm install --legacy-peer-deps"
            }
        }

        // Stage 4: OWASP Dependency Check
        stage('OWASP Dependency Check') {
            steps {
                echo 'Stage 4: Running OWASP dependency vulnerability check...'
                sh """
                docker run --rm -v jenkins_data:/var/jenkins_home -w ${WORKSPACE_PATH} \
                    -v /var/jenkins_home/dependency-check-data:/usr/share/dependency-check/data \
                    owasp/dependency-check:latest \
                    --project "Zomato-Clone" \
                    --scan . \
                    --format HTML --format XML \
                    --out .
                """
            }
        }

        // Stage 5: Trivy File System Scan
        stage('Trivy FS Scan') {
            steps {
                echo 'Stage 5: Scanning file system with Trivy...'
                sh "docker run --rm -v jenkins_data:/var/jenkins_home -w ${WORKSPACE_PATH} aquasec/trivy:latest fs --severity HIGH,CRITICAL --format table ."
            }
        }

        // Stage 6: Build & Push Docker Image
        stage('Build & Push Docker Image') {
            steps {
                echo 'Stage 6: Building Docker image...'
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} -t ${REGISTRY}/${IMAGE_NAME}:latest ."
                echo 'Pushing Docker image to Local Registry...'
                sh "docker login -u admin -p admin123 ${REGISTRY}"
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:latest"
                sh "docker logout ${REGISTRY}"
            }
        }

        // Stage 7: Trivy Image Scan
        stage('Trivy Image Scan') {
            steps {
                echo 'Stage 7: Scanning built Docker image with Trivy...'
                sh "docker run --rm aquasec/trivy:latest image --severity HIGH,CRITICAL ${REGISTRY}/${IMAGE_NAME}:latest"
            }
        }

        // Stage 8: Deploy Container
        stage('Deploy Container') {
            steps {
                echo 'Stage 8: Deploying Zomato Clone container...'
                sh "docker rm -f ${IMAGE_NAME} || true"
                sh "docker run -d --name ${IMAGE_NAME} --network evops_network -p 3001:80 ${REGISTRY}/${IMAGE_NAME}:latest"
            }
        }
    }
}
