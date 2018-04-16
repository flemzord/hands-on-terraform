output "lb_address" {
  value = "${aws_lb.apache.dns_name}"
}
