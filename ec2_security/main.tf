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
    Name = "Web publica"
  }
}

resource "aws_route_table" "rota_privada" {
  vpc_id = "${aws_vpc.rede.id}"

  tags = {
    Name = "Web privada"
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

resource "aws_security_group" "seg" {
  name        = "seg"
  description = "regras de acesso publico"
  vpc_id      = "${aws_vpc.rede.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web servers"
  }
}

resource "aws_security_group" "seg-lb" {
  name        = "seg-lb"
  description = "segurança do lb"
  vpc_id      = "${aws_vpc.rede.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Load Balancer"
  }
}

resource "aws_lb" "lb" {
  name            = "ALB"
  security_groups = ["${aws_security_group.seg-lb.id}"]
  subnets         = ["${aws_subnet.public_a.id}"]

  tags {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.rede.id}"

  health_check = {
    path              = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "lbl" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }
}
