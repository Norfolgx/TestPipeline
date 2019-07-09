resource "aws_instance" "ec2" {
  subnet_id = "${var.subnet_id}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.app.id}"]
  iam_instance_profile = "${var.instance_profile}"
  associate_public_ip_address = true
  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}

resource "aws_security_group" "app" {
  name = "${var.app_name}-SG"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}
