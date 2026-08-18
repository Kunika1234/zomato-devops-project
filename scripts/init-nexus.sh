#!/bin/bash
set -e

# ==========================================
# 1. Provision SonarQube
# ==========================================
echo "Waiting for SonarQube to be UP..."
until curl -s http://sonarqube:9000/sonarqube/api/system/status | grep -q '"status":"UP"'; do
    sleep 5
done
echo "SonarQube is UP."

# Try to change SonarQube admin password to admin123
# We allow failure in case it's already been changed in a previous container run
echo "Changing SonarQube admin password to admin123..."
curl -s -u admin:admin -X POST "http://sonarqube:9000/sonarqube/api/users/change_password?login=admin&previousPassword=admin&password=admin123" || echo "SonarQube password change skipped (already changed)."

# ==========================================
# 2. Provision Nexus
# ==========================================
echo "Waiting for Nexus to be healthy..."
until $(curl --output /dev/null --silent --head --fail http://nexus:8081/nexus/service/rest/v1/status); do
    sleep 5
done
echo "Nexus is healthy."

# Wait a few more seconds for the API to fully stabilize
sleep 5

if [ -f /nexus-data/admin.password ]; then
    echo "First-time setup: admin.password found."
    PASSWORD=$(cat /nexus-data/admin.password)
    echo "Retrieved temporary password."
    
    echo "Changing admin password to admin123..."
    curl -s -u "admin:$PASSWORD" -X PUT "http://nexus:8081/nexus/service/rest/v1/security/users/admin/change-password" \
         -H "Content-Type: text/plain" \
         -d "admin123"
fi

echo "Ensuring Docker hosted repository on port 8082..."
curl -s -u "admin:admin123" -X POST "http://nexus:8081/nexus/service/rest/v1/repositories/docker/hosted" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "docker-private",
           "online": true,
           "storage": {
             "blobStoreName": "default",
             "strictContentTypeValidation": true,
             "writePolicy": "ALLOW"
           },
           "docker": {
             "v1Enabled": false,
             "forceBasicAuth": true,
             "httpPort": 8082
           }
         }' || echo "Docker private repo creation skipped or already exists."

echo "Activating Docker Bearer Token Realm..."
curl -s -u "admin:admin123" -X PUT "http://nexus:8081/nexus/service/rest/v1/security/realms/active" \
     -H "Content-Type: application/json" \
     -d '["NexusAuthenticatingRealm", "DockerToken"]'
     
echo "Nexus provisioning complete!"
