FROM alpine:3.19

# Install curl and bash during the build phase
RUN apk add --no-cache curl bash

# Copy the initialization script and make it executable
COPY init-nexus.sh /init-nexus.sh
RUN chmod +x /init-nexus.sh

# Normalize line endings in the container to handle potential Windows CRLF issues
RUN tr -d '\r' < /init-nexus.sh > /tmp/init-nexus.sh && \
    mv /tmp/init-nexus.sh /init-nexus.sh && \
    chmod +x /init-nexus.sh

ENTRYPOINT ["/bin/bash", "/init-nexus.sh"]
