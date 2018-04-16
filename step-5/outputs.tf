output "lb_address" {
  value = "${aws_lb.test.dns_name}"
}

terraform {
  backend "s3" {
    bucket = "devoxx-bucket"
    key    = "hands-on"
    region = "eu-west-3"
  }
}
