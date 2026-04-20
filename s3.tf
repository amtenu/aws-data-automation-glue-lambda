resource "aws_s3_bucket" "data_lake" {
  bucket = var.s3_bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Cosmetic folder markers — S3 has no real folders, just keys with slashes.
# These empty objects make the intended structure visible in the console
# before any data lands. Not required for Glue or Athena to function.
resource "aws_s3_object" "folders" {
  for_each = toset(["landing/", "processed/", "athena/", "scripts/"])

  bucket  = aws_s3_bucket.data_lake.id
  key     = each.value
  content = ""
}
