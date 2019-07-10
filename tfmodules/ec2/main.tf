resource "aws_instance" "ec2" {
  subnet_id = "${var.subnet_id}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.app.id}"]
  iam_instance_profile = "${var.instance_profile}"
  user_data = <<EOF
    #!/bin/bash
EOF
  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}

resource "aws_security_group" "app" {
  name = "${var.app_name}-SG"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.29.0.0/16"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}
