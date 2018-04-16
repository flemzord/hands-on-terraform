#
# TODO:
#
#

resource "aws_lb" "test" {
  name     = "devoxx-lb"
  internal = false

  security_groups = [
    "${data.terraform_remote_state.step2.security_group_id}",
  ]

  subnets = ["${data.aws_subnet.devoxx_subnet_details.*.id}"]
}

resource "aws_lb_target_group" "test" {
  name     = "devoxx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.devoxx_vpc.id}"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.test.arn}"
  target_id        = "${data.terraform_remote_state.step2.instance_id}"
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.test.arn}"
    type             = "forward"
  }
}

resource "aws_instance" "instance2" {
  tags = {
    Name = "${var.name}"
  }

  instance_type = "${var.instance_type}"

  ami      = "${var.instance_ami}"
  key_name = "${data.terraform_remote_state.step2.keypair_name}"

  # network
  associate_public_ip_address = true
  subnet_id                   = "${element(data.aws_subnet.devoxx_subnet_details.*.id, 0)}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.step2.security_group_id}"]

  user_data = <<EOF
#cloud-config
runcmd:
  - yum install -y httpd
  - curl http://169.254.169.254/latest/meta-data/instance-id > /var/www/html/index.html
  - systemctl start httpd
  - systemctl enable httpd
EOF

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = "${aws_lb_target_group.test.arn}"
  target_id        = "${aws_instance.instance2.id}"
  port             = 80
}
