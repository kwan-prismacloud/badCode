# Specify the provider (AWS in this case)
provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

# Generate a random string for the S3 bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create an S3 bucket with a random name
resource "aws_s3_bucket" "drifted_bucket" {
  bucket = "drifted-bucket-${random_string.bucket_suffix.result}"
  # Tags for the S3 bucket
  tags = {
    Name      = "DriftedBucket"
    yor_name  = "drifted_bucket"
    yor_trace = "9db6d040-6e69-42eb-869e-acd77e573430"
  }
}

resource "aws_s3_bucket_ownership_controls" "drifted_bucket" {
  bucket = aws_s3_bucket.drifted_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "drifted_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.drifted_bucket]

  bucket = aws_s3_bucket.drifted_bucket.id
  acl    = "private"
}

# Output the name of the created S3 bucket
output "s3_bucket_name" {
  value = aws_s3_bucket.drifted_bucket.bucket
}