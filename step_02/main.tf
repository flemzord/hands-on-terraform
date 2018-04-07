data "aws_vpc" "this" {
  cidr_block = "${var.host_cidr}"
}

data "aws_subnet_ids" "this" {
  vpc_id = "${data.aws_vpc.this.id}"
}

data "aws_subnet" "this" {
  count = "${length(data.aws_subnet_ids.this.ids)}"
  id    = "${data.aws_subnet_ids.this.ids[count.index]}"
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair-key"
  public_key = "${var.instance_keypair}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_vpc.this.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_instance" "instance" {
  tags = {
    Name = "${var.name}"
  }

  instance_type = "${var.instance_type}"

  ami      = "${var.instance_ami}"
  key_name = "${aws_key_pair.keypair.key_name}"

  # network
  associate_public_ip_address = true
  subnet_id                   = "${element(data.aws_subnet.this.*.id, count.index)}"
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }
}

output "instance_ip" {
  value = "${aws_instance.instance.public_ip}"
}
