#!/bin/bash

# Bu script, belirtilen Docker Swarm servisinin loglarını getirir ve ctrl+c ile düzgün bir şekilde durdurulabilir.

# Kullanım: ./dsl <servis-ismi>

# Gerekli değişkenler
SERVICE_NAME=$1
DOCKER_MASTER="$LAB_DOCKER_MASTER_USER@$LAB_DOCKER_MASTER_HOST"
SSH_OPTS="-o ServerAliveInterval=60"

# ctrl+c basıldığında çalışacak fonksiyon
function cleanup {
	echo "Stopping..."
	exit 0
}

# Catch Ctrl+C
trap cleanup SIGINT

# Find Service Node
NODE=$(ssh $SSH_OPTS $DOCKER_MASTER "docker service ps $SERVICE_NAME --filter 'desired-state=running' --format '{{.Node}}' | head -n 1")

if [ -z "$NODE" ]; then
	echo "Service node not found"
	exit 1
fi

CONTAINER_ID=$(ssh $SSH_OPTS $LAB_DOCKER_MASTER_USER@$NODE "docker ps --filter 'name=$SERVICE_NAME' --format '{{.ID}}' | head -n 1")

if [ -z "$CONTAINER_ID" ]; then
	echo "Service not found"
	exit 1
fi

# Get Logs
ssh -t $SSH_OPTS $LAB_DOCKER_MASTER_USER@$NODE "docker logs $CONTAINER_ID --tail 200 -ft"
