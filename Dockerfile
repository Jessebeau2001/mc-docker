FROM alpine:latest as base

# Setup info
LABEL org.opencontainers.image.authors="jessegamen@gmail.com"
LABEL version="0.0.1"
LABEL description="WIP dockerized minecraft container."

# Set main directory
WORKDIR /minecraft

# Setup envs
ENV MC_SERVER_DIR=/minecraft/server/
ENV MC_VERSION="FABRIC-1.20.4"
ENV MC_SESSION_NAME="minecraft-server"

# Copy necessary files
COPY server/ server/
COPY --chmod=+x mcscripts/ scripts/

# Install java runtime package (for minecraft)
RUN apk add --no-cache openjdk21-jre-headless
# Install bash (for run scripts)
RUN apk add --no-cache bash

# Expose mc ports
EXPOSE 25565/tcp
EXPOSE 25565/udp

ENTRYPOINT [ "/minecraft/scripts/lifecycle.sh" ]
