pipeline {
    agent any

    environment {
        // Using your DockerHub username and repository name
        IMAGE_NAME = "shivaamaroju/trie"
        CONTAINER_NAME = "myapp-container"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Login to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-token',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Building the image with the current build number as the tag
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                // Also tagging it as 'latest' for convenience
                sh 'docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                // Pushing both the specific build tag and the latest tag
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Pull Image from DockerHub') {
            steps {
                // This ensures the local VM has the exact version we just pushed
                sh 'docker pull $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                // '|| true' prevents the pipeline from failing if the container doesn't exist
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh '''
                docker run -d \
                --name $CONTAINER_NAME \
                -p 8090:80 \
                $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        always {
            // Optional: Clean up images locally to save VM space
            // sh 'docker rmi $IMAGE_NAME:$IMAGE_TAG'
            sh 'docker logout'
        }
    }
}
