#
# TODO: Ecrire un output nommé 'instance_ip' pour exposer l'attribut 'public_ip' de notre ressource 'instance'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#
output "instance_ip" {
  value = "${aws_instance.instance.public_ip}"
}

#
# TODO: Ecrire un output nommé 'instance_id' pour exposer l'attribut 'id' de notre ressource 'instance'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#
output "instance_id" {
  value = "${aws_instance.instance.id}"
}

#
# TODO: Ecrire un output nommé 'security_group_id' pour exposer l'attribut 'id' de notre ressource 'allow_all'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#
output "security_group_id" {
  value = "${aws_security_group.allow_all.id}"
}