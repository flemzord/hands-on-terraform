#
# TODO: Reprendre les éléments nécessaires des étapes précédentes. Il va vous falloir:
# * la keypair à assigner aux instances
# * un security_group à appliquer aux instances
#
# Vous pouvez au choix: les copier ou vous y raccorder via des requêtes datasources.
#

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


#
# TODO: Ecrire une ressource de type aws_autoscaling_group, de capacité 2, relié à la
# ressource target_group et à notre launch configuration.
#
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
#
