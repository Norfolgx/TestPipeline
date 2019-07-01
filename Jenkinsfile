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
            --role-session-name GeorgeTestPipeline-${environment}-JenkinsDeploy \
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
            println("Preparing credentials")
            def credsJson = readFile('../../tmp/assume-role-output.json')
            def credsObj = new groovy.json.JsonSlurperClassic().parseText(credsJson)
            println("Initialising Terraform")
            suppress_sh("""terraform init \
              -input=false \
              -backend-config='access_key=${credsObj.aws_access_key}' \
              -backend-config='secret_key=${credsObj.aws_secret_key}' \
              -backend-config='token=${credsObj.aws_security_token}' \
              """)
            sh("terraform plan")
          }
        }
        // dir(project_dir+"/tf/${environment}") {
        //   script {
        //     if ( "${params.ami}" != null && "${params.ami}" != '') {
        //       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
        //       println("Loading config json for backend initialisation")
        //       def read_json = readFile(file:"../../tmp/terraform_config.json")
        //       def config_json = new JsonSlurperClassic().parseText(read_json)

        //       println("Initialising TF Provider plugin")
        //       suppress_sh("""terraform init \
        //         -input=false \
        //         -backend-config='bucket=\"${config_json.bucket}\"' \
        //         -backend-config='region=\"${config_json.region}\"' \
        //         -backend-config='access_key=\"${config_json.aws_access_key}\"' \
        //         -backend-config='secret_key=\"${config_json.aws_secret_key}\"' \
        //         -backend-config='token=\"${config_json.aws_security_token}\"' \
        //         """)

        //       println("Running terraform build")
        //       sh("""terraform apply \
        //         -auto-approve \
        //         -var-file=../../tmp/terraform_config.json \
        //         -var ami="${params.ami}"
        //         """)
        //       }
        //     } else {
        //     println('FATAL: ami not passed out of packer, not updating any infrastructure')
        //     }
        //   }
        // }
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
        cleanWs()
      }
    }
  }
}
