terraform {
  backend "s3" {
    bucket = "sltest11"
    key = "GeorgeTestPipeline-tf.state"
    region = "eu-west-1"
    encrypt = true
  }
}
