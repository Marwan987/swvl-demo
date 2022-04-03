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

    stage('Push') {
      environment {
        registry = 'marwan-docker'
      }
   steps {
        script {
          commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
          def appimage = docker.build imageName + ":" + commitId.trim()
          docker.withRegistry( 'https://index.docker.io/v1/', registry ) {
            appimage.push()
            if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'release') {
              appimage.push('latest')
              if (env.BRANCH_NAME == 'release') {
                appimage.push("release-" + "${COMMIT_SHA}")
              }
          }
         }
       }
     }
   }
    
    stage('Deploy to DEV') {
      steps {
          step([$class: 'KubernetesEngineBuilder', 
                        projectId: "triple-voyage-278712",
                        clusterName: "swvl-cluster",
                        zone: "us-central1",
                        manifestPattern: 'swvl-deployments/dev',
                        credentialsId: "triple-voyage-278712",
                        verifyDeployments: true])
      }
    }
    stage('Deploy to PROD') {
      steps {
          step([$class: 'KubernetesEngineBuilder',
                        projectId: "triple-voyage-278712",
                        clusterName: "swvl-cluster",
                        zone: "us-central1",
                        manifestPattern: 'swvl-deployments/prod',
                        credentialsId: "triple-voyage-278712",
                        verifyDeployments: true])
      }
    }
  }
}

