    properties([ parameters([
    booleanParam(defaultValue: false, description: 'Apply All Changes', name: 'terraformApply'),
    booleanParam(defaultValue: false, description: 'Destroy deployment', name: 'terraformDestroy')
    
    ])])

      node('master') {
            stage('Poll code') {
              checkout scm
            }

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

          stage("Testing the application") {
            dir("${WORKSPACE}/deployments/terraform") {
              sh '''#!/bin/bash -e                  
              for i in $(cat public_ip_address.txt);  do ./bash_scripts/healtcheck.sh $i 8080; done'''
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