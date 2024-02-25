resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Environment = var.env
  }

}

resource "aws_s3_bucket_public_access_block" "bucket-pab" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:DeleteObject", "s3:PutObject"]
        Resource  = "${aws_s3_bucket.s3.arn}/*"
      },
    ]
  })
}