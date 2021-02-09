provider "aws" {
  region = "${var.region}"
}

data "template_file" "policy" {
  template = "${file("templates/policy.json")}"

  vars {
    bucket_name = "${var.domain}"
  }
}

resource "null_resource" "site_files"{
    triggers{
        react_build = "${md5("../website/html")}"
    }

    provisioner "local-exec" {
        command = "aws s3 sync ../website/ s3://${var.domain}"
    }

    depends_on = ["aws_s3_bucket.site"]
}