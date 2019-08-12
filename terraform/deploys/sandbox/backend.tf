terraform {
  backend "s3" {
    bucket = "georgetestpipeline"
    key = "GeorgeTestPipeline-tf.state"
    region = "eu-west-1"
    encrypt = true
  }
}
