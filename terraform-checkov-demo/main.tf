resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-demo-bucket"
}

resource "aws_s3_bucket_public_access_block" "secure_access" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

