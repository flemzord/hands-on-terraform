#
# TODO: Ecrire un output nommé 'instance_ip' pour exposer l'attribut 'public_ip' de notre ressource 'instance'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#


#
# TODO: Ecrire un output nommé 'instance_id' pour exposer l'attribut 'id' de notre ressource 'instance'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#


#
# TODO: Ecrire un output nommé 'security_group_id' pour exposer l'attribut 'id' de notre ressource 'allow_all'
# Hints:
#   https://www.terraform.io/intro/getting-started/outputs.html#defining-outputs
#


output "keypair_name" {
  value = "${aws_key_pair.keypair.key_name}"
}
