pipeline {
  agent any
    
  tools {nodejs "node"}
    
  stages {
        
    stage('Git') {
      steps {
		checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'marwan3', url: 'git@github.com:Marwan987/swvl-demo.git']]])
      }
    }
     
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }  
    
            
    stage('prep') {
    agent {
        docker {
            image 'mongo'
            args '--name realworld-mongo -p 27017:27017 & sleep 10'
        }
    }
  }
    stage('Test') {
      steps {
        sh 'node app.js'
        sh 'npm test'
      }
    }
  }
}

