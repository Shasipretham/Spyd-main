pipeline { 

    agent any 

 

    environment { 

        CONTAINER_NAME = 'Spyd' 

        CONTAINER_NAME_N = 'spf' 

        IMAGE_NAME = 'image'          // Docker image name 

        DOCKER_REGISTRY = 'docker.io'  // Docker registry (Docker Hub) 

        DOCKER_REPO = 'sasipretham/spydmains' // Replace with your Docker Hub username/repository 

        TAG = "1.0"                 // Tag for the Docker image (e.g., latest or versioned) 

    } 

 

    stages { 

        stage ('Installing dependices'){ 

             steps { 

                echo 'Installing.....' 

                sh 'sudo yum install git -y' 

                sh 'sudo yum install docker -y' 

                sh 'sudo systemctl enable docker' 

                sh 'sudo systemctl start docker' 

                sh 'sudo usermod -aG docker jenkins' 

                //sh 'sudo systemctl restart jenkins' 

            } 

        } 

        stage('Clone From Git') { 

            steps { 

                echo 'Cloning repository from GitHub' 

                git branch: 'main', url: 'https://github.com/Shasipretham/Spyd-main.git' 

            } 

        } 

 

        stage('Build a Docker Image') { 

            steps { 

                echo 'Building Docker image' 

                sh 'docker build -t $DOCKER_REPO:$TAG .' 

            } 

        } 

 

        stage('Build a Docker Container') { 

            steps { 

                echo 'Running Docker container' 

                //sh 'docker stop $CONTAINER_NAME ' 

                //sh 'docker rm $CONTAINER_NAME' 

                sh 'docker run -d --name $CONTAINER_NAME -p 80:80 $DOCKER_REPO:$TAG' 

            } 

        } 

 

        stage('Push to Docker Hub') { 

            steps { 

                script { 

                    // Login to Docker Hub using the credentials 

                    withCredentials([usernamePassword(credentialsId: 'shasi-docker', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) { 

                        // Login to Docker Hub 

                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin' 

                    } 

 

                    // Push the Docker image to Docker Hub 

                    echo 'Pushing Docker image to Docker Hub' 

                    sh 'docker push $DOCKER_REPO:$TAG' 

                } 

            } 

        } 

 

        stage('Deleting container and Images') { 

            steps { 

                echo 'Deleting container and images...' 

                sh 'docker rm -f $CONTAINER_NAME || true' 

                sh 'docker rm -f $CONTAINER_NAME_N || true' 

                sh 'docker rmi $DOCKER_REPO:$TAG || true' 

                sh 'docker system prune -af || true' 

            } 

        } 

 

        stage('Pull the Docker image') { 

            steps { 

                echo 'Pulling Docker image from Docker Hub' 

                sh 'docker pull $DOCKER_REPO:$TAG' 

            } 

        } 

 

        stage('Create a New Container') { 

            steps { 

                echo 'Creating a new Docker container' 

                sh 'docker run -d --name $CONTAINER_NAME_N -p 5173:80 $DOCKER_REPO:$TAG' 

            } 

        } 

    } 

 

    post { 

        success { 

            echo "Pipeline succeeded!" 

        } 

 

        failure { 

            echo "Pipeline failed!" 

        } 

    } 

} 
