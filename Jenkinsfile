pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose action to perform')
    choice(name: 'ENVIRONMENT', choices: ['dev', 'qa', 'prod'], description: 'Select environment')
    string(name: 'PROJECT_NAME', defaultValue: 'avdproj', description: 'Project name prefix')
  }

  environment {
    ARM_CLIENT_ID        = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET    = credentials('AZURE_CLIENT_SECRET')
    ARM_SUBSCRIPTION_ID  = credentials('AZURE_SUBSCRIPTION_ID')
    ARM_TENANT_ID        = credentials('AZURE_TENANT_ID')
  }

    stage('Set Project Prefix') {
      steps {
        script {
          sh "echo 'project = \"${params.PROJECT_NAME}-${params.ENVIRONMENT}\"' > override.auto.tfvars"
        }
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
          if (params.ACTION == 'apply') {
            sh "terraform plan -var-file=${tfvarsFile}"
          } else {
            sh "terraform plan -destroy -var-file=${tfvarsFile}"
          }
        }
      }
    }

    stage('Terraform ${params.ACTION}') {
      steps {
        script {
          def tfvarsFile = "${params.ENVIRONMENT}.tfvars"
          if (params.ACTION == 'apply') {
            input message: "Proceed with APPLY to ${params.ENVIRONMENT}?"
            sh "terraform apply -auto-approve -var-file=${tfvarsFile}"
          } else {
            input message: "Proceed with DESTROY from ${params.ENVIRONMENT}?"
            sh "terraform destroy -auto-approve -var-file=${tfvarsFile}"
          }
        }
      }
    }
  }

  post {
    failure {
      echo "Terraform ${params.ACTION} failed for ${params.ENVIRONMENT}!"
    }
  }
}
