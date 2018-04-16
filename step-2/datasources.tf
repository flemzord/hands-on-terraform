#
# TODO: Ecrire une datasource de type aws_vpc pour récupérer le vpc créé au step-1
# Hints:
#   https://www.terraform.io/docs/providers/aws/d/vpc.html
#

data "aws_subnet_ids" "devoxx_subnets" {
  vpc_id = "${data.aws_vpc.devoxx_vpc.id}"
}

data "aws_subnet" "devoxx_subnet_details" {
  count = "${length(data.aws_subnet_ids.devoxx_subnets.ids)}"
  id    = "${data.aws_subnet_ids.devoxx_subnets.ids[count.index]}"
}
