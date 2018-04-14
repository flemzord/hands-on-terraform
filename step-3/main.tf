#
# TODO:
#
#

resource "aws_lb" "test" {
  name            = "devoxx-lb"
  internal        = false

  security_groups = [
    "${data.terraform_remote_state.step2.security_group_id}"
  ]

  subnets         = ["${data.aws_subnet.devoxx_subnet_details.*.id}"]
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