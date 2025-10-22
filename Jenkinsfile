pipeline {
  agent any

  environment {
    IMAGE_NAME = "israelrop4/flask-ci-cd"
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    GITHUB_CREDENTIALS = credentials('github-creds')
    NAMESPACE = "devops"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/jacoisrael2/flask-ci-cd.git',
            credentialsId: 'github-creds'
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        sh '''
          echo "✅ Building image..."
          docker build -t $IMAGE_NAME:latest .
          
          echo "🔐 Logging into Docker Hub..."
          echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
          
          echo "🚀 Pushing image to Docker Hub..."
          docker push $IMAGE_NAME:latest
        '''
      }
    }

    stage('Deploy on K3s') {
      steps {
        sh '''
        echo "🛠️ Deploying to K3s..."
        helm upgrade --install flask-ci-cd ./helm -n $NAMESPACE \
          --set image.repository=$IMAGE_NAME,image.tag=latest
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline completed successfully! Flask app deployed to K3s."
    }
    failure {
      echo "❌ Pipeline failed. Check Jenkins logs for details."
    }
  }
}

