pipeline {
    agent any

    environment {
        IMAGE_NAME = "pravab369/simple-app"
        DOCKERHUB_CREDENTIALS = "dockerhub-pat-token"
        COMPOSE_FILE = "docker-compose.yml"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/n-pravab/AT_JenDoc.git'
            }
        }

        stage('Build Docker Image and Update docker-compose.yml') {
            steps {
                script {
                    // Run the build.sh script

                    sh 'chmod +x build.sh'
                    sh './build.sh'

                    // Read the TAG value from tag.txt
                    env.TAG = sh(script: 'cat tag.txt', returnStdout: true).trim()
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pat-token', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        def imageName = env.IMAGE_NAME

                        sh "echo \"${DOCKER_PASSWORD}\" | docker login -u \"${DOCKER_USERNAME}\" --password-stdin"
                        sh "docker push ${imageName}:${env.TAG}"
                    }
                }
            }
        }

        stage('Restart Container') {
            steps {
                script {
                    sh "docker compose up -d --force-recreate"
                }
            }
        }
    }
}