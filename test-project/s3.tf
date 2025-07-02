resource "aws_s3_bucket" "utcbucket" {
  bucket = var.bucket_name
  force_destroy = var.destroy
}