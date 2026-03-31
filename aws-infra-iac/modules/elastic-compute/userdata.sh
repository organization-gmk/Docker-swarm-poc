#!/bin/bash
set -e

# Install Docker
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Tag node role
echo "NODE_ROLE=${node_role}" >> /etc/environment
echo "ENVIRONMENT=${environment}" >> /etc/environment
