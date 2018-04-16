#
# TODO: Reprendre les éléments nécessaires des étapes précédentes. Il va vous falloir:
# * la keypair à assigner aux instances
# * un security_group à appliquer aux instances
#
# Vous pouvez au choix: les copier ou vous y raccorder via des requêtes datasources.
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


resource "aws_lb" "apache" {
  name     = "devoxx-lb"
  internal = false

  security_groups = [
    "${aws_security_group.allow_all.id}",
  ]

  subnets = ["${data.aws_subnet.devoxx_subnet_details.*.id}"]
}

#
# TODO: Créer une ressource aws_lb_target_group nommée 'apache' qui permette de laisser passer
# du protocole HTTP sur le port 80.
#
#
resource "aws_lb_target_group" "apache" {
  name     = "devoxx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.devoxx_vpc.id}"

  health_check {
    protocol            = "HTTP"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.apache.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.apache.arn}"
    type             = "forward"
  }
}

#
# TODO: Ecrire une ressource de type aws_launch_configuration, qui définira nos instances
# Ce qui était fait manuellement précédemment sur les instances sera lancé au démarrage.
# Le script e démarrage doit être le suivant :
#
#  user_data = <<EOF
#  #cloud-config
#  runcmd:
#    - yum install -y httpd
#    - curl http://169.254.169.254/latest/meta-data/instance-id > /var/www/html/index.html
#    - systemctl start httpd
#    - systemctl enable httpd
#  EOF
#
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
#   https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/user-data.html
#
resource "aws_launch_configuration" "lc" {
  name            = "${var.name}-lc"
  image_id        = "${var.instance_ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "${aws_key_pair.keypair.key_name}"
  security_groups = ["${aws_security_group.allow_all.id}"]

  user_data = <<EOF
#cloud-config
runcmd:
  - yum install -y httpd
  - curl http://169.254.169.254/latest/meta-data/instance-id > /var/www/html/index.html
  - systemctl start httpd
  - systemctl enable httpd
EOF
}

#
# TODO: Ecrire une ressource de type aws_autoscaling_group, de capacité 2, relié à la
# ressource target_group et à notre launch configuration.
#
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
#
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.name}-asg"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.lc.name}"

  target_group_arns = [
    "${aws_lb_target_group.apache.arn}",
  ]

  vpc_zone_identifier = [
    "${data.aws_subnet.devoxx_subnet_details.*.id}",
  ]

  tags = [
    {
      key                 = "Name"
      value               = "${var.name}-asg"
      propagate_at_launch = true
    },
  ]
}
