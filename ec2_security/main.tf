provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "rede" {
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "Web"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = "${aws_vpc.rede.id}"
  cidr_block        = "${var.public_a_cidr}"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public a"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = "${aws_vpc.rede.id}"
  cidr_block        = "${var.private_a_cidr}"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private 1a"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.rede.id}"

  tags = {
    Name = "Web"
  }
}

resource "aws_route_table" "rota_publica" {
  vpc_id = "${aws_vpc.rede.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Web"
  }
}

resource "aws_route_table" "rota_privada" {
  vpc_id = "${aws_vpc.rede.id}"

  tags = {
    Name = "Web"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.rota_publica.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.rota_privada.id}"
}
