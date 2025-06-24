pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose action to perform')
    choice(name: 'ENVIRONMENT', choices: ['dev'], description: 'Select environment')
    string(name: 'PROJECT_NAME', defaultValue: 'avdproj', description: 'Project name prefix')
  }

  environment {
    ARM_CLIENT_ID        = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET    = credentials('AZURE_CLIENT_SECRET')
    ARM_SUBSCRIPTION_ID  = credentials('AZURE_SUBSCRIPTION_ID')
    ARM_TENANT_ID        = credentials('AZURE_TENANT_ID')

    LOCAL_BIN = "${WORKSPACE}/.local/bin"
    TF_VERSION = "1.7.5"
    GCP_PROJECT = "test-data-462007" // <-- Set your actual project ID
  }

  stages {
    stage('Install Terraform Locally') {
      steps {
        sh '''
          mkdir -p "$LOCAL_BIN"
          export PATH="$LOCAL_BIN:$PATH"

          if ! [ -x "$LOCAL_BIN/terraform" ]; then
            echo "Installing Terraform locally to $LOCAL_BIN"
            curl -fsSL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o terraform.zip
            unzip -o terraform.zip
            mv terraform "$LOCAL_BIN/"
            chmod +x "$LOCAL_BIN/terraform"
          fi

          terraform version
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          export PATH="$LOCAL_BIN:$PATH"
          cd gcp-terraform
          terraform init
        '''
      }
    }

    stage('Terraform Plan') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh '''
          export PATH="$LOCAL_BIN:$PATH"
          cd gcp-terraform
          terraform plan -var="project_id=${GCP_PROJECT}" -var-file=terraform.tfvars
        '''
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh '''
          export PATH="$LOCAL_BIN:$PATH"
          cd gcp-terraform
          terraform apply -auto-approve -var="project_id=${GCP_PROJECT}" -var-file=terraform.tfvars
        '''
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        sh '''
          export PATH="$LOCAL_BIN:$PATH"
          cd gcp-terraform
          terraform destroy -auto-approve -var="project_id=${GCP_PROJECT}" -var-file=terraform.tfvars
        '''
      }
    }
  }

  post {
    failure {
      echo "❌ Terraform ${params.ACTION} failed for ${params.ENVIRONMENT}!"
    }
  }
}
