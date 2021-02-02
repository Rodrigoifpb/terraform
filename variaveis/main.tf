# configurando provedor
provider "aws"{
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "web" {
  ami = "${var.ami}"
  instance_type = "${var.type}"
  ipv6_addresses = "${var.ips}"
  tags = "${var.tags}"
}