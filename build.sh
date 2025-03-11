#!/bin/bash

# Build the Docker image with the timestamped tag
IMAGE_NAME="pravab369/simple-app"
TAG=$(date +%Y.%m.%d-%H.%M.%S)
COMPOSE_FILE="docker-compose.yml"

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME:$TAG"
docker build -t ${IMAGE_NAME}:${TAG} .

# Optionally tag the image as 'latest'
echo "Tagging the image as latest"
docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

# Update docker-compose.yml with the new image tag
echo "Updating docker-compose.yml to use the new image tag"
sed -i "s|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${TAG}|" ${COMPOSE_FILE}

# Save TAG to a file so Jenkins can read it
echo $TAG > tag.txt