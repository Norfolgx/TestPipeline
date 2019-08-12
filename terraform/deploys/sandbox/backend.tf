terraform {
  backend "s3" {
    bucket = "lnuk-devops-tfstate"
    key = "george-test-pipeline-sandbox.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
