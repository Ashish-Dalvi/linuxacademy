pipeline {

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    agent any

    tools {
        maven 'maven_3.6.3'
    }

    stages {
        stage('Code Compilation') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('QA Execution') {
            steps {
                sh 'mvn clean test'
            }
        }

        stage('Code Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
           steps {
                sh 'docker build -t linuxacademy .'
           }
         }

        stage('Upload Docker to DockerRegistry') {
           steps {
		      script {
			     withCredentials([string(credentialsId: 'dockerhubC', variable: 'dockerhubC')]){
                 sh 'docker login docker.io -u ashishdalvi -p ${dockerhubC}'
                 echo "Push Docker Image to DockerHub : In Progress"
                 sh 'docker tag 265d205cd580 ashishdalvi/linuxacademy:jenkins-${JOB_NAME}-${BUILD_NUMBER}'
				 sh 'docker push ashishdalvi/linuxacademy:jenkins-${JOB_NAME}-${BUILD_NUMBER}'
				 echo "Push Docker Image to DockerHub : In Progress"
				 }
              }
            }
        }

        stage('Upload Docker Image to AWS ECR') {
            steps {
			   script {
			      withDockerRegistry([credentialsId:'ecr:ap-south-1:ecr-credentials', url:"https://761561323244.dkr.ecr.ap-south-1.amazonaws.com/linuxacademy"]){
                  sh """
                  echo "List the docker images present in local"
                  docker images
				  echo "Tagging the Docker Image: In Progress"
				  docker tag linuxacademy:latest 761561323244.dkr.ecr.ap-south-1.amazonaws.com/linuxacademy:latest
				  echo "Tagging the Docker Image: Completed"
				  echo "Push Docker Image to ECR : In Progress"
				  docker push 761561323244.dkr.ecr.ap-south-1.amazonaws.com/linuxacademy:latest
				  echo "Push Docker Image to ECR : Completed"
				  """
				  }
                }
            }
		}
        stage('Upload the docker Image to Nexus') {
            steps {
                sh 'date;date;date'
            }
        }
        stage('Deploy to Production') {
            steps {
                nexusArtifactUploader artifacts: [
                [
                artifactId: 'linuxacademy',
                classifier: '',
                file: 'target/linuxacademy-1.0.0.war',
                type: 'war'
                ]
             ],
             credentialsId: '0f8c40e3-e0fb-4daf-82e3-1ed42b2645d4',
             groupId: 'com.radical',
             nexusUrl: '172.31.40.225:8081',
             nexusVersion: 'nexus3', protocol: 'http', repository: 'http://13.235.16.225:8081/repository/linuxacademy/',
             version: '0.0.1'
            }
        }

    }
}