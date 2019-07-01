provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn = "${var.role_arn}"
    session_name = "${var.session_name}"
  }
}

module "ec2" {
  source = "../../tfmodules/ec2"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
  app_name = "${var.app_name}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  instance_profile = "${var.instance_profile}"
  guid = "${var.guid}"
  asset_id = "${var.asset_id}"
}