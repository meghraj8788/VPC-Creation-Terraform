resource "aws_s3_bucket" "example" {
  bucket = "my-tfbucketmeghraj8788"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}