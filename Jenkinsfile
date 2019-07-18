import groovy.json.JsonSlurperClassic
def suppress_sh(cmd) {
  sh(
    script: '#!/bin/sh +x \n' + cmd
  )
}
pipeline {
  agent any
  parameters {
    choice(name: 'environment', choices: ['sandbox', 'nonprod'], description: 'Environment to deploy to.')
    booleanParam(name: 'buildAmi', defaultValue: false, description: 'Build a new ami?')
  }
  environment {
    PATH = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin"
    AWS_MAX_ATTEMPTS = "150"
    AWS_POLL_DELAY_SECONDS = "30"
    TF_LOG = "DEBUG"
    TF_LOG_PATH = "${WORKSPACE}/log/terraformlog.txt"
    PACKER_LOG = 1
    PACKER_LOG_PATH = "${WORKSPACE}/log/packerlog.txt"
  }
  stages {
    stage('Setting Up, Assuming Roles, Preparing Credentials') {
      steps {
        script {
          print("Creating folder structure")
          sh 'mkdir -p tmp'
          sh 'mkdir -p log'
          print("Declaring dynamic variables")
          sessionName = "GeorgeTestPipeline-${environment}-JenkinsDeploy"
          switch (environment) {
            case "sandbox":
              role = "arn:aws:iam::466157028690:role/CrossAccountAccess-ForRundeck"
              region = "eu-west-1"
              break
            case "nonprod":
              role = "arn:aws:iam::871282733788:role/CrossAccountAccess-ForRundeck"
              region = "eu-west-1"
              break
          }
          print("Assuming role")
          sh("aws sts assume-role \
            --role-arn ${role} \
            --role-session-name ${sessionName} \
            --region ${region} \
            > tmp/assume-role-output.json")
          print("Preparing credentials")
          credsJson = readFile("${WORKSPACE}/tmp/assume-role-output.json")
          credsObj = new groovy.json.JsonSlurperClassic().parseText(credsJson)
        }
      }
    }
    stage('Build application') {
      steps {
        script {
          dir("${WORKSPACE}/app") {
            if(params.buildAmi) {
              print("Building application")
              dir("${WORKSPACE}/app/ClientApp") {
                sh 'npm install'
              }
              sh 'dotnet publish -c Release'
              dir("${WORKSPACE}/app/bin/Release/netcoreapp2.1/") {
                sh "zip -r ${WORKSPACE}/tmp/publish.zip publish/"
              }
            } else {
              print("Skipping application build")
            }
          }
        }
      }
    }
    stage('Provisioning AMI with Packer and Ansible') {
      steps {
        script {
          if(params.buildAmi) {
            print("Packer build")
            suppress_sh("packer build \
              -var 'access_key=${credsObj.Credentials.AccessKeyId}' \
              -var 'secret_key=${credsObj.Credentials.SecretAccessKey}' \
              -var 'token=${credsObj.Credentials.SessionToken}' \
              ${WORKSPACE}/packer/packer.json \
              ")
          } else {
            print("Skipping Packer build")
          }
        }
      }
    }
    stage('Deploying infrastructure with Terraform') {
      steps {
        dir("${WORKSPACE}/terraform/deploys/${environment}") {
          script {
            print("Initialising Terraform")
            sh("terraform init -input=false")
            print("Deploying Terraform")
            sh("terraform apply \
              -auto-approve \
              -var 'role_arn=${role}' \
              -var 'session_name=${sessionName}' \
              -var 'region=${region}'")
          }
        }
      }
    }
  }
  post {
    always {
      script {
        print("End of Jekinsfile!")
        sh 'rm -rf tmp'
        sh 'rm -rf log'
        cleanWs()
      }
    }
  }
}
