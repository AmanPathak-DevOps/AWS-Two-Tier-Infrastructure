properties([
    parameters([
        string(defaultValue: 'Terraform-Infrastructure-Deployment', name: 'Pipeline'),
        choice(choices: ['plan', 'apply', 'destroy'], name: 'Terraform_Action')
    ])
])
pipeline {
    agent any
    stages {
        stage('Preparing') {
            steps {
                sh 'echo Preparing'
            }
        }
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Git Pulling') {
            steps {
                git branch: 'master', 
                credentialsId: 'GITHUB-TOKEN',
                url: 'https://github.com/AmanPathak-DevOps/AWS-Two-Tier-Infrastructure.git'
            }
        }
        stage('Init') {
            steps {
                echo "Pipeline Name ${params.Pipeline}"
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                sh 'terraform init'
                }
            }
        }
        stage('Action') {
            steps {
                echo "${params.Terraform_Action}"
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                sh 'terraform get -update' 
                    script {    
                        if (params.Terraform_Action == 'plan') {
                            sh 'terraform plan -var-file=variables.tfvars'
                        }   else if (params.Terraform_Action == 'apply') {
                            sh 'terraform -chdir=Non-Modularized/${File_Name}/ apply -var-file=variables.tfvars -auto-approve'
                        }   else if (params.Terraform_Action == 'destroy') {
                            sh 'terraform -chdir=Non-Modularized/${File_Name}/ destroy -var-file=variables.tfvars -auto-approve'
                        } else {
                            error "Invalid value for Terraform_Action: ${params.Terraform_Action}"
                        }
                    }
                }
            }
        }
    }
}