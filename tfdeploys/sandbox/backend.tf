terraform {
  backend "s3" {
    bucket = "sltest11"
    key = "${var.app_name}-tf.state"
    region = "${var.region}"
    encrypt = true
  }
}
