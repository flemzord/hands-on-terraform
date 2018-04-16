#
# TODO: Créer une ressource de type 'aws_lb' nommée 'first' et liée à tous les subnets de notre datasource aws_subnet
# et dans le security_group de votre datasource 'step2'
#
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/lb.html
#

resource "aws_lb_target_group" "first_tg" {
  name     = "devoxx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.devoxx_vpc.id}"
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = "${aws_lb_target_group.first_tg.arn}"
  target_id        = "${data.terraform_remote_state.step2.instance_id}"
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.first.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.first_tg.arn}"
    type             = "forward"
  }
}

#
# TODO: Créer une instance ec2 en piochant certaines valeurs d'attribut dans variables.tf
# Le security_group doit être le même que celui créé en step-2.
# Le script de démarrage doit être le suivant :
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

#
# TODO: Attacher l'instance créée au target_group 'first_tg'
#
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html
#
