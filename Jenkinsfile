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
            environment {
                MONGODB_URI = "mongodb://adminuser:password123@mongo-nodeport-svc:27017/real-app?authSource=admin"
                NODE_ENV = "production"
                SECRET = "secret"
            }
      steps {
        echo env.MONGODB_URI
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
