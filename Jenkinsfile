pipeline {
   agent any
    environment {
  
        registryCredential = 'dockerhub_id'
        registry = "azhar6039/samplemaven"
        dockerImage = ''
    }
    
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/azhar6039/samplemaven.git']]])  
            }
        }
    stage('Build') {
		  steps {
			  sh "echo Packaging Sample MiddleWare Application"
			  sh "mvn clean package"
		  }
    }
  
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }
    stage('Upload Image') {
     steps{    
         script {
            docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
            }
        }
      }
    }
    stage ('K8S Deploy') {
        steps {
            script {
                kubernetesDeploy(
                    configs: 'k8s-deployment.yaml',
                    kubeconfigId: 'K8S',
                    enableConfigSubstitution: true
                    )           
               
            }
        }
    }
    }
}
