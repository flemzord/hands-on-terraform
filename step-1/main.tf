#
# Datasource pour récupérer les AZ de notre région d'opération.
#
data "aws_availability_zones" "all" {}

#
# Ici nous créons les ressources réseau pour déployer notre application. Pour plus de simplicité,
# on se limite à un subnet public par AZ.
#
# Plus de détail sur le pattern AWS ici :
#
#   https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html
#
resource "aws_vpc" "network" {
  cidr_block                       = "${var.vpc_cidr}"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = "${map("Name", "${var.project_name}")}"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.network.id}"

  tags = "${map("Name", "${var.project_name}")}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.network.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.gateway.id}"
  }

  tags = "${map("Name", "${var.project_name}")}"
}

resource "aws_subnet" "public" {
  #
  # Utilisation de l'attribut 'count' pour créer plusieurs ressources identiques
  # Détails ici :
  #   https://www.terraform.io/docs/configuration/resources.html#count
  #
  count = "${length(data.aws_availability_zones.all.names)}"

  #
  # TODO: Remplir l'attribut vpc_id avec l'attribut 'id' de la ressource 'network' de type 'aws_vpc'
  #


  #
  # Utilisation de l'index de count pour attribuer une AZ différente à chacun des subnets créé.
  #
  availability_zone = "${data.aws_availability_zones.all.names[count.index]}"

  cidr_block                      = "${cidrsubnet(var.vpc_cidr, 4, count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.network.ipv6_cidr_block, 8, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = "${map("Name", "${var.project_name}-public-${count.index}")}"
}

resource "aws_route_table_association" "public" {
  count = "${length(data.aws_availability_zones.all.names)}"

  route_table_id = "${aws_route_table.default.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}
