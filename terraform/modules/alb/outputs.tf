output "alb_sg" {
  value = "${aws_security_group.alb.id}"
}
output "alb_dns_name" {
  value = "${aws_lb.app.dns_name}"
}
output "alb_zone_id" {
  value = "${aws_lb.app.zone_id}"
}
