pipeline {
  agent any

  environment {
    ARM_CLIENT_ID        = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET    = credentials('AZURE_CLIENT_SECRET')
    ARM_SUBSCRIPTION_ID  = credentials('AZURE_SUBSCRIPTION_ID')
    ARM_TENANT_ID        = credentials('AZURE_TENANT_ID')
  }

  stages {
    stage('Checkout Code') {
      steps {
        git 'https://github.com/<your-org>/azure-avd-terraform.git'
      }
    }

    stage('Init Terraform') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Plan Infrastructure') {
      steps {
        sh 'terraform plan -var-file=terraform.tfvars'
      }
    }

    stage('Apply Infrastructure') {
      steps {
        input message: "Proceed with Apply?"
        sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
      }
    }
  }

  post {
    failure {
      echo "Terraform apply failed!"
    }
  }
}