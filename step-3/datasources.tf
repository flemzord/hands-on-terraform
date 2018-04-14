#
# TODO: Créer une datasource 'step2' de type 'terraform_remote_state' avec un backed 'local' aui pointe sur le fichier
# tfstate du répertoire step-2
#
# Hints:
#   https://www.terraform.io/docs/backends/types/local.html
#
data "terraform_remote_state" "step2" {
  backend = "local"

  config {
    path = "${path.module}/../step-2/terraform.tfstate"
  }
}


data "aws_vpc" "devoxx_vpc" {
  cidr_block = "10.10.0.0/16"
}

data "aws_subnet_ids" "devoxx_subnets" {
  vpc_id = "${data.aws_vpc.devoxx_vpc.id}"
}

data "aws_subnet" "devoxx_subnet_details" {
  count = "${length(data.aws_subnet_ids.devoxx_subnets.ids)}"
  id    = "${data.aws_subnet_ids.devoxx_subnets.ids[count.index]}"
}
