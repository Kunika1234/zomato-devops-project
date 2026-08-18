FROM jenkins/jenkins:lts-jdk17

USER root

# Copy Docker CLI binary directly from the official Docker CLI image
COPY --from=docker:cli /usr/local/bin/docker /usr/local/bin/docker

# Disable Jenkins Setup Wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Configure update center download mirrors to force LeaseWeb downloads directly
# This bypasses updates.jenkins.io mirror redirection which was sending requests to a broken mirror
ENV JENKINS_UC=https://updates.jenkins.io/update-center.json
ENV JENKINS_UC_DOWNLOAD=https://mirror.leaseweb.com/jenkins

# Pre-install plugins using Jenkins Plugin CLI
RUN jenkins-plugin-cli --plugins \
    git \
    workflow-aggregator \
    docker-workflow \
    sonar \
    prometheus \
    configuration-as-code \
    job-dsl

# Set JCasC configuration path
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml

# Copy JCasC configuration file
COPY jenkins.yaml /var/jenkins_home/jenkins.yaml

# Default back to root for running docker commands on the socket
USER root
