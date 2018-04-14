#
# TODO: Ecrire un output pour exposer l'attribut 'public_ip' de notre ressource 'instance'
#
#
output "instance_ip" {
  value = "${data.terraform_remote_state.step2.instance_id}"
}

output "lb_address" {
  value = "${aws_lb.test.dns_name}"
}
