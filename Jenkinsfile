pipeline {
    agent any

    environment {
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
                // Added --no-cache to ensure index.html changes are picked up every time
                sh 'docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .'
                sh 'docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Pull Image from DockerHub') {
            steps {
                sh 'docker pull $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
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
            sh 'docker logout'
        }
        success {
            // Optional: Removes dangling images to keep your VM fast/clean
            sh 'docker image prune -f'
            echo "Deployment successful! Check http://<your-vm-ip>:8090"
        }
    }
}
