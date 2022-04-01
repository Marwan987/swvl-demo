pipeline {
  agent any
    
  tools {nodejs "node"}
    
  stages {
        
    stage('Git') {
      steps {
        git 'https://github.com/Marwan987/swvl-demo'
      }
    }
     
    stage('Build') {
      steps {
        sh 'npm install'
         sh 'node app.js'
      }
    }  
    
            
    stage('Test') {
      steps {
        sh 'node test'
      }
    }
  }
}
