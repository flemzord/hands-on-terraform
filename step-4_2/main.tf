#
# TODO: Reprendre les éléments nécessaires des étapes précédentes 
#
#
resource "aws_key_pair" "keypair" {
  key_name   = "devoxx-keypair"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_vpc.devoxx_vpc.id}"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_security_group_rule" "allow_all_in" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_all.id}"
}

resource "aws_security_group_rule" "allow_all_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_all.id}"
}

resource "aws_lb" "test" {
  name     = "devoxx-lb"
  internal = false

  security_groups = [
    "${aws_security_group.allow_all.id}",
  ]

  subnets = ["${data.aws_subnet.devoxx_subnet_details.*.id}"]
}

resource "aws_lb_target_group" "test" {
  name     = "devoxx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.devoxx_vpc.id}"

  health_check {
    protocol            = "TCP"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
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
