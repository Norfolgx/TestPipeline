terraform {
  backend "s3" {
    bucket = "aws-devops-ssm"
    key = "george-test-pipeline-sandbox.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
