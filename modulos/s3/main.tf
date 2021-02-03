resource "aws_s3_bucket" "this"{
    bucket = "${var.name}"
    acl = "${var.acl}"

    versioning {
        enabled = "${var.versioning}"
    }

    tags = "${var.tags}"

}