resource "aws_lb" "app" {
  name = "${var.app_name}"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets = ["${var.public_subnets}"]
  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}

# resource "aws_lb_target_group" "app" {
#   name_prefix = "${var.app_name}"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = "${var.vpc_id}"
#   lifecycle {
#     create_before_destroy = true
#   }
# }
#
# resource "aws_lb_listener" "app_https" {
#   load_balancer_arn = "${aws_lb.app.arn}"
#   port = "443"
#   protocol = "HTTPS"
#   certificate_arn = "${var.ssl_cert}"
#   default_action {
#     type             = "redirect"
#     redirect {
#       port = "80"
#       protocol = "HTTP"
#       status_code = "HTTP_301"
#     }
#   }
# }
#
# resource "aws_lb_listener" "app_http" {
#   load_balancer_arn = "${aws_lb.app.arn}"
#   port              = "80"
#   protocol          = "HTTP"
#   certificate_arn = "${var.ssl_cert}"
#   default_action {
#     type = "forward"
#     target_group_arn = "${aws_lb_target_group.app.arn}"
#   }
# }

resource "aws_lb_target_group" "app" {
  name_prefix = "${var.app_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "app_https" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port = "443"
  protocol = "HTTPS"
  certificate_arn = "${var.ssl_cert}"
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.app.arn}"
  }
}

resource "aws_lb_listener" "app_http" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#######################

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = "${aws_lb_target_group.app.arn}"
  target_id = "${var.ec2_instance}"
  port = 5000
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.app_name}-alb-sg"
  vpc_id = "${var.vpc_id}"
  lifecycle {
    create_before_destroy = true
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
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
