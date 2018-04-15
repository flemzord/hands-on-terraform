output "lb_address" {
  value = "${aws_lb.test.dns_name}"
}
