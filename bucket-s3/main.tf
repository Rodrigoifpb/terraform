# configurando provedor
provider "aws"{
    access_key = "chave"
    secret_key = "chave"
    region = "us-east-1"

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

#output "etag" {
#    value = "${aws_s3_bucket_object.object.etag}"
#}
