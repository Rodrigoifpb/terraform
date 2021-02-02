# configurando provedor
provider "aws"{
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_s3_bucket" "rodrigo" {
  bucket = "rodrigo-terraform-bucket"
  acl = "private"

  tags = {
    name = "My"
    Enviroment = "Prod"
  }
}

resource "aws_s3_bucket_object" "object" {
    bucket = "${aws_s3_bucket.rodrigo.id}"
    key = "arquivo.txt"
    source = "teste.txt"
#    etag = "${md5(file(teste.txt))}"
}

output "bucket" {
    value = "${aws_s3_bucket.rodrigo.id}"
}