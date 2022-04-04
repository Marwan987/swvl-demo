pipeline {
  agent any
   
    environment {
          BRANCH_NAME = scm.branches[0].name.split("/")[1]
  }
    
  stages {
        
    stage('Preparation') {
      steps { 
                sh 'echo 'Pulling... ' + env.GIT_BRANCH'
                sh 'env'
		checkout([$class: 'GitSCM', branches: [[name: '*/$BRANCH_NAME']], extensions: [], userRemoteConfigs: [[credentialsId: 'marwan3', url: 'git@github.com:Marwan987/swvl-demo.git']]])
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
      }
            post {
                always {
                     sh 'npm stop'
                     sh 'docker stop realworld-mongo && docker rm realworld-mongo'
                }
            }
    }

    stage('Push') {
      environment {
        imageName = 'real-app'
        dockerName = 'marwanaf'
      }
   steps {
        script {
          commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
          withDockerRegistry(credentialsId: 'marwan-docker', url: 'https://index.docker.io/v1/') {
           def realappimage = docker.build dockerName + "/" + imageName + ":" + commitId.trim()
              if (env.BRANCH_NAME == 'master') {
                realappimage.push('latest')
                realappimage.push( "release-" + commitId.trim() )
                }
               
              if (env.BRANCH_NAME == 'develop') {
                realappimage.push()
                realappimage.push('dev')
                }
           }
          }
         }
       }
    

    stage('Deploy to DEV') {
      when {
        branch 'develop'
      }
      steps {
          step([$class: 'KubernetesEngineBuilder', 
                        projectId: "triple-voyage-278712",
                        clusterName: "swvl-cluster",
                        zone: "us-central1",
                        manifestPattern: 'k8s/dev',
                        credentialsId: "triple-voyage-278712",
                        verifyDeployments: true])
      }
    }
    stage('Deploy to PROD') {
      when {
        branch 'master'
      }
      steps {
          step([$class: 'KubernetesEngineBuilder',
                        projectId: "triple-voyage-278712",
                        clusterName: "swvl-cluster",
                        zone: "us-central1",
                        manifestPattern: 'k8s/prod',
                        credentialsId: "triple-voyage-278712",
                        verifyDeployments: true])
      }
    }
  }
}

