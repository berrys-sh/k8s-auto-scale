resource "aws_s3_bucket" "wc_server_dev" {
  bucket = "wc-server-dev"

  tags = {
    Name        = "wc-server-dev"
    Environment = "dev"
  }
}