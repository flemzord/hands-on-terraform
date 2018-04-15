#
# TODO: Ecrire une ressource de type aws_s3_bucket
# Le versioning doit être activé
# Le bucket doit pouvoir être supprimé si des éléments sont présents.
# Hints:
#   https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
#

resource "aws_s3_bucket" "devoxx-bucket" {
  bucket = "${var.name}-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags {
    Name = "${var.name}-bucket"
  }
  force_destroy = true
}