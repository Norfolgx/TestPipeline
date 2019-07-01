provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  token = "${var.aws_security_token}"
  region = "${var.region}"
}

module "ec2" {
  source = "../tfmodules/ec2"
  subnet_id = "${var.subnet_id}"
  app_name = "${var.app_name}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  app_keyname = "${var.keyname}"
  app_instance_profile = "${var.instance_profile}"
  guid = "${var.guid}"
  asset_id = "${var.asset_id}"
}