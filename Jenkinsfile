Vpipeline {
  agent any

  environment {
    IMAGE_NAME = "seuusuario/flask-ci-cd"
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    NAMESPACE = "devops"
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/seuusuario/flask-ci-cd.git'
      }
    }

    stage('Build & Push Docker Image') {
      agent {
        docker {
          image 'docker:27.1.1-cli'
          args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
      }
      steps {
        sh 'docker build -t $IMAGE_NAME:latest .'
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh 'docker push $IMAGE_NAME:latest'
      }
    }

    stage('Deploy on K3s') {
      steps {
        sh '''
        helm upgrade --install flask-ci-cd ./helm -n $NAMESPACE \
          --set image.repository=$IMAGE_NAME,image.tag=latest
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline executado com sucesso! Aplicação Flask deployada no K3s."
    }
    failure {
      echo "❌ Pipeline falhou. Verifique os logs no Jenkins."
    }
  }
}

