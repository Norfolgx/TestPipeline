resource "aws_lb" "app" {
  name               = "${var.app_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${var.public_subnets}"]
  tags {
    Name = "${var.app_name}"
    GUID = "${var.guid}"
    AssetID = "${var.asset_id}"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.app_name}-tg"
  port     = 80 # make this 5000?
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app.arn}"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = "${aws_lb_target_group.app.arn}"
  target_id = "${var.ec2_instance}"
  port = 5000
}

resource "aws_security_group" "alb" {
  name = "${var.app_name}-alb-sg"
  vpc_id = "${var.vpc_id}"
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

resource "aws_route53_record" "app" {
  zone_id = "${var.zone_id}"
  name    = "${var.dns_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.alb.dns_name}"
    zone_id                = "${aws_lb.alb.zone_id}"
    evaluate_target_health = true
  }
}