pipeline {
  agent any

  parameters {
    choice(
      name: 'ACTION',
      choices: ['plan', 'apply', 'destroy'],
      description: 'Choose Terraform action'
    )
    choice(
      name: 'GCP_PROJECT',
      choices: ['test-data-462007', 'able-analyst-434310-q9'],
      description: 'Select GCP project'
    )
    choice(
      name: 'ENVIRONMENT',
      choices: ['dev', 'prod'],
      description: 'Select deployment environment'
    )
  }

  environment {
    GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-creds-file') // make sure this credential has access to both projects
    TF_VERSION = "1.7.5"
    LOCAL_BIN = "${env.WORKSPACE}/bin"
    PATH = "${env.WORKSPACE}/bin:${env.PATH}"
  }

  stages {
    stage('Install Terraform Locally') {
      steps {
        sh '''
          mkdir -p $LOCAL_BIN
          export PATH=$LOCAL_BIN:$PATH

          if ! [ -x "$LOCAL_BIN/terraform" ]; then
            echo "Installing Terraform locally to $LOCAL_BIN"
            curl -fsSL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o terraform.zip
            unzip -o terraform.zip
            mv terraform $LOCAL_BIN/
            chmod +x $LOCAL_BIN/terraform
          fi

          terraform version
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          export PATH=$LOCAL_BIN:$PATH
          cd gcp-terraform
          terraform init -input=false -backend-config="bucket=tfstate-462007" -backend-config="prefix=terraform/state/${GCP_PROJECT}"
        '''
      }
    }

    stage('Terraform Plan') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh '''
          export PATH=$LOCAL_BIN:$PATH
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
          export PATH=$LOCAL_BIN:$PATH
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
          export PATH=$LOCAL_BIN:$PATH
          cd gcp-terraform
          terraform destroy -auto-approve -var="project_id=${GCP_PROJECT}" -var-file=terraform.tfvars
        '''
      }
    }
  }
}
