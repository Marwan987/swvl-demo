pipeline {
  agent any
   
    
  stages {
        
    stage('Preparation') {
      steps { 
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
       sh 'npm test'
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
    stage('Deploy to QA') {
      when {
        branch 'master'
      }
      steps {
          step([$class: 'KubernetesEngineBuilder',
                        projectId: "triple-voyage-278712",
                        clusterName: "swvl-cluster",
                        zone: "us-central1",
                        manifestPattern: 'k8s/test',
                        credentialsId: "triple-voyage-278712",
                        verifyDeployments: true])
      }
    
            post {
                success {
                   sh 'newman run ./tests/api-tests.postman.json -e ./tests/env-api-tests.postman.json'
                   junit(testResults: 'newman/realapp.xml', allowEmptyResults : true)
                }
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

