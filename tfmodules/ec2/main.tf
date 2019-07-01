resource "aws_instance" "ec2" {
  subnet_id = "${var.app_subnet_id}"
  ami = "${var.app_ami}"
  instance_type = "${var.app_instance_type}"
  key_name = "${var.app_keyname}"
  security_groups = ["${aws_security_group.app.id}"]
  iam_instance_profile = "${var.app_instance_profile}"

  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}