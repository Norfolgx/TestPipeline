provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn = "${var.role_arn}"
    session_name = "${var.session_name}"
  }
}

data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Name"
    values = ["GeorgePackerTest"]
  }
}

module "ec2" {
  source = "../../modules/ec2"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
  app_name = "${var.app_name}"
  ami = "${data.aws_ami.image.id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  instance_profile = "${var.instance_profile}"
  guid = "${var.guid}"
  asset_id = "${var.asset_id}"
  alb_sg = "${module.alb.alb_sg}"
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = "${var.vpc_id}"
  app_name = "${var.app_name}"
  guid = "${var.guid}"
  asset_id = "${var.asset_id}"
  public_subnets = "${var.public_subnets}"
  ec2_instance = "${module.ec2.ec2_instance}"
}
