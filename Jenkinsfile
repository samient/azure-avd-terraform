pipeline {
  agent any

  parameters {
    choice( name: 'ACTION', choices: ['apply', 'destroy'],  description: 'Choose whether to apply or destroy'
    )
  }

  environment {
    ARM_CLIENT_ID        = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET    = credentials('AZURE_CLIENT_SECRET')
    ARM_SUBSCRIPTION_ID  = credentials('AZURE_SUBSCRIPTION_ID')
    ARM_TENANT_ID        = credentials('AZURE_TENANT_ID')
  }

    stage('Init Terraform') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Plan Infrastructure') {
      steps {
        script {
          if (params.ACTION == 'apply') {
            sh 'terraform plan -var-file=terraform.tfvars'
          } else {
            sh 'terraform plan -destroy -var-file=terraform.tfvars'
          }
        }
      }
    }

    stage('Execute Terraform') {
      steps {
        script {
          if (params.ACTION == 'apply') {
            input message: "Proceed with APPLY?"
            sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
          } else {
            input message: "Proceed with DESTROY?"
            sh 'terraform destroy -auto-approve -var-file=terraform.tfvars'
          }
        }
      }
    }
  }

  post {
    failure {
      echo "Terraform ${params.ACTION} failed!"
    }
  }
}
