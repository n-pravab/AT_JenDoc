#!/bin/bash

# image name with dynamic tag
IMAGE_NAME="pravab369/simple-app"
TAG=$(date +%Y.%m.%d-%H.%M.%S)

docker build -t $IMAGE_NAME:$TAG .

# push to Docker Hub
# docker push $IMAGE_NAME:$TAG

# Output the tag in a structured way for Jenkins
echo "BUILT_IMAGE_TAG=$TAG"

# pdate docker-compose.yml with the latest tag
sed -i "s|image: $IMAGE_NAME:.*|image: $IMAGE_NAME:$TAG|" ./docker-compose.yml

echo "Updated docker-compose.yml with image: $IMAGE_NAME:$TAG"
