terraform {
  backend "s3" {
    bucket = "lnuk-devops-tfstate"
    key = "GeorgeTestPipeline/sandbox.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
