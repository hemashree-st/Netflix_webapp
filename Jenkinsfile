pipeline{
    agent any

    tools{
        maven 'maven'
    }
    
    environment {
        DOCKER_HUB_USERNAME = 'hemashree642'
        DOCKER_CRED_ID      = 'dockerhub-credentials-id'
        IMAGE_TAG       = "${env.BUILD_NUMBER}"
        IMAGE_LATEST    = 'latest'
    }

    stages {
        stage('src pull') {
            steps {
                git branch:"master" url:https://github.com/hemashree-st/Netflix_webapp.git""
            }
            post{
                success{
                    echo "successfully pulled"
                }
                failure{
                    echo "unable to pull"
                }
            }
        }

        stage('Build stage') {
            steps {
                sh 'mvn clean package -DskipTests'
                
            }
            post{
                success{
                    echo "Build success"
                }
                failure{
                    echo "Build failure"
                }
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID,
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh "sudo docker login -u $DOCKER_USER -p $DOCKER_PASS"
                }
            }
            post{
                success{
                    echo "login successful"
                }
                failure{
                    echo "login failed"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "sudo docker build -t ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG} ."
                sh "sudo docker tag ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG} ${env.DOCKER_HUB_REPO}:${env.IMAGE_LATEST}"
            }
            post{
                success{
                    echo "docker image built successfully"
                }
                failure{
                    echo "failed to build docker image"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh "sudo docker push ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}"
                sh "sudo docker push ${env.DOCKER_HUB_REPO}:${env.IMAGE_LATEST}"
            }
            post{
                success{
                    echo "docker image pushed successfully"
                }
                failure{
                    echo "failed to push docker image"
                }
            }
        }

        stage('Clean Up Local Images') {
            steps {
                sh "sudo docker rmi ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG} || true"
                sh "sudo docker rmi ${env.DOCKER_HUB_REPO}:${env.IMAGE_LATEST} || true"
            }
            post{
                success{
                    echo "local image cleaned successfully"
                }
                failure{
                    echo "failed to clean local images"
                }
            }
        }

        stage('Run Container') {
            steps {
                sh "sudo docker stop my_app_container || true"
                sh "sudo docker rm my_app_container || true"
                sh "sudo docker run -d --name my_app_container -p 8080:8080 ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}"
            }
            post{
                success{
                    echo "container is running successfully"
                }
                failure{
                    echo "failed to run the container"
                }
            }
        }
}

}