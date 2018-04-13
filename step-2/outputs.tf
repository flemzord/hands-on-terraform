#
# TODO: Ecrire un output pour exposer l'attribut 'public_ip' de notre ressource 'instance'
#
#
output "instance_ip" {
  value = "${aws_instance.instance.public_ip}"
}
