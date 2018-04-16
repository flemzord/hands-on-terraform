#
# TODO: Créer une configuration de backend de type s3 qui enregistre vos tfstates dans le bucket créé
# en step-4.
#
#
terraform {
  backend "s3" {
    bucket = "devoxx-bucket"
    key    = "hands-on"
    region = "eu-west-3"
  }
}
