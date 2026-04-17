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
                        credentialsId: 'docker_hub_token',
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
                if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
                    docker stop $CONTAINER_NAME
                    docker rm $CONTAINER_NAME
                fi
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh '''
                docker run -d \
                --name $CONTAINER_NAME \
                -p 80:80 \
                $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }
}
