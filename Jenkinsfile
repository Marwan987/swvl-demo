pipeline {
  agent any
    
    
  stages {
        
    stage('Preparation') {
      steps {
		checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'marwan3', url: 'git@github.com:Marwan987/swvl-demo.git']]])
      }
    }
     
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }  
    
            
    stage('Test') {
      steps {
        sh 'docker run --name realworld-mongo -p 27017:27017 mongo & sleep 5'
        sh 'npm start &'  
        sh 'npm test'
        sh 'npm stop'
        sh 'docker stop realworld-mongo && docker rm realworld-mongo'
      }
    }
    stage('Publish') {
      steps {
        withDockerRegistry(credentialsId: 'marwan-docker', url: 'https://hub.docker.com/repository/docker/marwanaf/real-app') {
          sh  'docker build -t marwanaf/real-app:test' .
          sh  'docker push'
          }
      }
    }
  }
}

