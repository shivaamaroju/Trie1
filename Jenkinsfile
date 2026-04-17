pipeline {
    agent any

    environment {
        IMAGE_NAME = "shivaamaroju/trie"
        CONTAINER_NAME = "myapp-container"
        IMAGE_TAG = "v1"
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
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }
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
}
