provider "aws"{
    region = "${var.region}"
}

resource "random_id" "bucket"  {
  byte_length = 8
}

module "bucket-rdg" {
    source = "./s3"

    name = "meu-bucket-${random_id.bucket.hex}"

    tags = {
        "Name" = "arquivos diversos"
    }

    create_object = true
    object_key = "files/${random_id.bucket.dec}.txt"
    object_source = "file.txt"
}