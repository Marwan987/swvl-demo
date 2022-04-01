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
        docker.image('mongo').withRun('--name realworld-mongo -p 27017:27017') { }
        sh "printenv"
        sh 'npm install'
        sh 'node app.js'
      }
    }  
    
            
    stage('Test') {
      steps {
        sh 'npm test'
      }
    }
  }
}
