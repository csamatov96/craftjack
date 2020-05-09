    properties([ parameters([
    booleanParam(defaultValue: false, description: 'Apply All Changes', name: 'terraformApply'),
    booleanParam(defaultValue: false, description: 'Destroy deployment', name: 'terraformDestroy')
    ])])

      node('master') {
            stage('Poll code') {
              checkout scm
            }
          //build process
          stage("Build Image"){
            dir("${WORKSPACE}/deployments/docker") {
                sh "docker build -t app:${APP_VERSION} ." // 
            }
          }

          stage("Build Tag"){
            dir("${WORKSPACE}/deployments/docker") {
                  sh '''docker tag app:${APP_VERSION} 951251854577.dkr.ecr.us-east-1.amazonaws.com/repo:${APP_VERSION}''' //ecr creds 
            }
          }
          stage("Login to ECR"){
            dir("${WORKSPACE}/deployments/docker") {
                  sh '''$(aws ecr get-login --no-include-email --region us-east-1)''' //ecr creds
            }
          }
          
          stage("Push Image"){
            dir("${WORKSPACE}/deployments/docker") {
                  sh "docker images"
                  sh "docker push 951251854577.dkr.ecr.us-east-1.amazonaws.com/repo:${APP_VERSION}" //
            }
          }
          //actual deploy process on ec2 with all installed and configured 
          stage('Terraform Apply/Plan') {
            if (!params.terraformDestroy) {
              if (params.terraformApply) {

                dir("${WORKSPACE}/deployments/terraform") {
                  echo "##### Terraform Applying the Changes ####"
                  sh '''#!/bin/bash -e
                  terraform init
                  terraform apply --auto-approve -var-file=deployment_configuration.tfvars'''
                }

              } else {

                  dir("${WORKSPACE}/deployments/terraform") {
                    echo "##### Terraform Plan (Check) the Changes #####"
                    sh '''#!/bin/bash -e
                    terraform init
                    terraform plan -var-file=deployment_configuration.tfvars'''
                  }

              }
            }
          }
          //testing stage 
          stage("Testing the application") {
            dir("${WORKSPACE}/deployments/terraform") { //dotnet test
              sh '''#!/bin/bash -e dotnet test'''
            }
          }

          stage('Terraform Destroy') {
            if (!params.terraformApply) {
              if (params.terraformDestroy) {
                dir("${WORKSPACE}/deployments/terraform") {
                echo "##### Terraform Destroing #####"
                sh '''#!/bin/bash -e
                terraform init
                terraform destroy --auto-approve -var-file=deployment_configuration.tfvars'''
                }
              }
           }

           if (params.terraformDestroy) {
             if (params.terraformApply) {
               println("""
               Sorry you can not destroy and apply at the same time
               """)
             }
         }
       }
   }