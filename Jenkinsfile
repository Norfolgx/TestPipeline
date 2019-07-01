import groovy.json.JsonSlurperClassic
def suppress_sh(cmd) {
  sh(
    script: '#!/bin/sh -e\n' + cmd,
    returnStdout: false
  )
}
pipeline {
  agent any
  parameters {
    choice(name: 'environment', choices: ['sandbox', 'nonprod'], description: 'Environment to deploy to.')
  }
  environment {
    PATH = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin"
    AWS_MAX_ATTEMPTS = "150"
    // Terraform parameters
    TF_LOG = "DEBUG"
    TF_LOG_PATH = "${WORKSPACE}/log/terraformlog.txt"
    // Packer parameters
    PACKER_LOG = 1
    PACKER_LOG_PATH = "${WORKSPACE}/log/packerlog.txt"
    AWS_POLL_DELAY_SECONDS = "30" // For Packer to avoid request limit (TF has exponential backoff built in)
  }
  stages {
    stage('Setting Up, Assuming Roles, Exporting Credentials') {
      steps {
        script {
          print("Declaring dynamic variables")
          sessionName = "GeorgeTestPipeline-${environment}-JenkinsDeploy"
          print("Creating folder structure")
          sh 'mkdir -p tmp'
          sh 'mkdir -p log'
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
          suppress_sh("aws sts assume-role \
            --role-arn ${role} \
            --role-session-name ${sessionName} \
            --region ${region} \
            > tmp/assume-role-output.json"
          )
        }
      }
    }
    stage('Deploying infrastructure with Terraform') {
      steps {
        dir("${WORKSPACE}/tfdeploys/${environment}") {
          script {
            print("Preparing credentials")
            def credsJson = readFile("${WORKSPACE}/tmp/assume-role-output.json")
            def credsObj = new groovy.json.JsonSlurperClassic().parseText(credsJson)
            print("Initialising Terraform")
            suppress_sh("""terraform init \
              -input=false \
              -backend-config='access_key=${credsObj.Credentials.AccessKeyId}' \
              -backend-config='secret_key=${credsObj.Credentials.SecretAccessKey}' \
              -backend-config='token=${credsObj.Credentials.SessionToken}' \
              """)
            print("Deploying Terraform")
            sh("""terraform apply \
              -auto-approve \
              -var 'role_arn=${role}' \
              -var 'session_name=${sessionName}' \
              -var 'region=${region}'
              """)
          }
        }
      }
    }
  }
  post {
    success {
      script {
        print("The Build Succeeded!")
      }
    }
    failure {
      script {
        print("The Build Failed!")
      }
    }
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
