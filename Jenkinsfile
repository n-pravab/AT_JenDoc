pipeline {
    agent any

    environment {
        IMAGE_NAME = "pravab369/simple-app"
        DOCKERHUB_CREDENTIALS = "dockerhub-pat-token"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/n-pravab/AT_JenDoc.git'
            }
        }

        stage('Make Build Script Executable') {
            steps {
                sh 'chmod +x build.sh'
                sh '''
                    head ./docker-compose.yml
                    docker image ls | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'echo "BUILD_NUMBER is: $BUILD_NUMBER"'
                sh './build.sh'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pat-token', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${FULL_IMAGE_NAME}"
            }
        }

        stage('Deploy with Docker Compose') {
    steps {
        script {
            def topTag = sh(script: "curl -s 'https://hub.docker.com/v2/repositories/pravab369/simple-app/tags/?page_size=100' | jq -r '.results[].name' | sort -r | head -n 1", returnStdout: true).trim()
            echo "Top tag: $topTag"
            def fullImageName = "$IMAGE_NAME:$topTag"
            def imageExists = sh(script: "docker images -q $fullImageName", returnStdout: true).trim()
            
            if (imageExists) {
                echo "Image already exists locally. Running container using Docker Compose..."
                sh 'docker-compose up -d'
            } else {
                echo "Pulling image from Docker Hub and running with Docker Compose..."
                sh "docker pull $fullImageName"
                sh 'docker-compose up -d'
            }
        }
    }
}
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}

