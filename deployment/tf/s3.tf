resource "aws_s3_bucket" "wc_server_dev" {
  bucket = "wc-server-dev"

  tags = {
    Name        = "wc-server-dev"
    Environment = "dev"
  }
}
resource "aws_s3_bucket_policy" "wc_server_dev_policy" {
  bucket = aws_s3_bucket.wc_server_dev.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.wc_server_dev.arn}/*"
      }
    ]
  })
}