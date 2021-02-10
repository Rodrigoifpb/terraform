variable "region" {
  default = "us-east-1"
}

variable "cidr_block" {
  default = "10.10.0.0/16"
}

variable "public_a_cidr" {
  default = "10.10.1.0/24"
}

variable "private_a_cidr" {
  default = "10.10.4.0/23"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-047a51fa27710816e"
}

variable "key_pair" {
  default = "rodrigo"
}