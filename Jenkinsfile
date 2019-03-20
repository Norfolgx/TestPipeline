pipeline {
  agent any
  paramaters {
    choice(name: 'choice', choices: "choice1\nchoice2", description: 'Everything is a test')
    booleanParam(name: 'boolean', defaultValue: true, description: "Is this a test?")
  }
  stages {
    stage('Stage 1') {
      steps {
        println("Test ${choice} println.")
        }
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
