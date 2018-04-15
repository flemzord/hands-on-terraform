#
# TODO: Ecrire un output pour exposer l'attribut 'dns_name' de notre ressource 'lb'
#
#
output "lb_address" {
  value = "${aws_lb.test.dns_name}"
}
