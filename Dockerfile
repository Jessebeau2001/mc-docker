FROM alpine:latest as base

# Setup info
LABEL org.opencontainers.image.authors="jessegamen@gmail.com"
LABEL version="0.0.1"
LABEL description="WIP dockerized minecraft container."

# Set main directory
WORKDIR /minecraft

# Setup envs
ENV MC_SERVER_DIR=/minecraft/server/
ENV SERVER_JAR=minecraft-server.jar

# Append command script to container's root .bashrc
# COPY scripts/commands.sh /tmp/commands.sh
# RUN cat /tmp/commands.sh >> /root/.bashrc && rm /tmp/commands.sh
COPY --chmod=+x scripts/ scripts/

# Install java runtime package (for minecraft)
RUN apk add --no-cache openjdk21-jre-headless

# Install udev lib (minecraft whines if it doesn't have this)
RUN apk add --no-cache eudev-libs

# Install bash (for running scripts)
RUN apk add --no-cache bash

# Expose mc ports
EXPOSE 25565/tcp
EXPOSE 25565/udp

ENTRYPOINT [ "/minecraft/scripts/lifecycle.sh" ]
