resource "aws_instance" "ec2" {
  subnet_id = "${var.subnet_id}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.keyname}"
  security_groups = ["${aws_security_group.app.id}"]
  iam_instance_profile = "${var.instance_profile}"

  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}