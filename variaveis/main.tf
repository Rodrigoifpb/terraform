# configurando provedor
provider "aws"{
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instace" "web" {
  ami = "${var.ami}"
  instance_type = "${var.type}"
  ivp4_addresses = "${var.ips}"
  tags = "${var.tags}"
}