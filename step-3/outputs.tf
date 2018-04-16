output "test_address" {
  value = "http://${aws_lb.first.dns_name}"
}
