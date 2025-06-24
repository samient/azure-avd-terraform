pipeline {
  agent {
    docker {
      image 'hashicorp/terraform:1.7.5'
      args '-u root' // Run as root (if needed)
    }
  }

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
  }

  stages {
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/samient/azure-avd-terraform.git', credentialsId: 'github-creds'
      }
    }

    stage('Set Project Prefix') {
      steps {
        sh '''
          echo "project = \\"${PROJECT_NAME}-${ENVIRONMENT}\\"" > override.auto.tfvars
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        script {
          def tfvarsFile = "${params.ENVIRONMENT}.tfvars"
          def planCommand = params.ACTION == 'apply' 
              ? "terraform plan -var-file=${tfvarsFile}" 
              : "terraform plan -destroy -var-file=${tfvarsFile}"
          sh planCommand
        }
      }
    }

    stage('Execute Terraform') {
      steps {
        script {
          def tfvarsFile = "${params.ENVIRONMENT}.tfvars"
          if (params.ACTION == 'apply') {
            input message: "Proceed with APPLY?"
            sh "terraform apply -auto-approve -var-file=${tfvarsFile}"
          } else {
            input message: "Proceed with DESTROY?"
            sh "terraform destroy -auto-approve -var-file=${tfvarsFile}"
          }
        }
      }
    }
  }

  post {
    failure {
      echo "❌ Terraform ${params.ACTION} failed for ${params.ENVIRONMENT}!"
    }
  }
}
