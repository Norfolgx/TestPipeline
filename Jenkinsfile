import groovy.json.JsonSlurperClassic

// def app_name = "PipelineTest"
// def project_dir = "PipelineTest"

pipeline {
  agent any
  parameters {
    choice(name: 'choice', choices: "choice1\nchoice2", description: 'Everything is a test')
    booleanParam(name: 'boolean', defaultValue: true, description: "Is this a test?")
  }
  /*environment {
    //PATH = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin"
    //PACKER_LOG = 1
    //PACKER_LOG_PATH = "${WORKSPACE}/${project_dir}/log/packerlog.txt"
    //TF_LOG = "DEBUG"
    //TF_LOG_PATH = "${WORKSPACE}/${project_dir}/log/terraformlog.txt"
    //AWS_POLL_DELAY_SECONDS = "30" // For Packer to avoid request limit (TF has exponential backoff built in)
    //AWS_MAX_ATTEMPTS = "150"
  }*/
  stages {
    stage('Stage 1') {
      steps {
        println("Test Stage 1 println.")
        }
      }
    stage('Stage 2') {
      steps {
        println("Test ${choice} println.")
      }
    }
  }
  post {
    failure {
      println("Write out upon Failure.")
    }
    success {
      println("Write out upon Success")
    }
    always {
      println("Write out Always.")
    }
  }
}
