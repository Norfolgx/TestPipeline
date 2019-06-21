import groovy.json.JsonSlurperClassic
import java.io.File

def project_dir = "MyApp"
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
    TF_LOG_PATH = "${WORKSPACE}/${project_dir}/log/terraformlog.txt"
    // Packer parameters
    PACKER_LOG = 1
    PACKER_LOG_PATH = "${WORKSPACE}/${project_dir}/log/packerlog.txt"
    AWS_POLL_DELAY_SECONDS = "30" // For Packer to avoid request limit (TF has exponential backoff built in)
  }
  stages {
    stage('Setting Up, Assuming Roles, Exporting Credentials') {
      steps {
        dir(project_dir) {
          script {
            println("Creating folder structure")
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
            println("Assuming role")
            suppress_sh("aws sts assume-role \
              --role-arn ${role} \
              --role-session-name ${project_dir}-${environment}-JenkinsDeploy \
              --region ${region} \
              > tmp/assume-role-output.json"
            )
            File file = new File('tmp/assume-role-output.json')
            def credsJson = file.getText()
            def credsObj = new groovy.json.JsonSlurperClassic().parseText("tmp/assume-role-output.json")
            secretAccessKey = credsObj.Credentials.SecretAccessKey
            accessKeyId = credsObj.Credentials.AccessKeyId
            sessionToken = credsObj.Credentials.SessionToken
            println(sessionToken)
          }
        }
      }
    }
  }
  post {
    success {
      script {
        println("The Build Succeeded!")
      }
    }
    failure {
      script {
        println("The Build Failed!")
      }
    }
    always {
      script {
        println("End of Jekinsfile!")
        sh 'rm -rf tmp'
        sh 'rm -rf log'
      }
    }
  }
}
