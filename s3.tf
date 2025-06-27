resource "aws_kms_key" "ecr_viewer" {
  enable_key_rotation = true
}

resource "aws_kms_key" "logging" {
  enable_key_rotation = true
}

resource "aws_s3_bucket" "ecr_viewer" {
  bucket        = local.s3_viewer_bucket_name
  force_destroy = true
  tags          = local.tags
}

resource "aws_s3_bucket_public_access_block" "ecr_viewer" {
  bucket                  = aws_s3_bucket.ecr_viewer.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ecr_viewer" {
  bucket = aws_s3_bucket.ecr_viewer.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ecr_viewer.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "ecr_viewer" {
  bucket = aws_s3_bucket.ecr_viewer.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "logging" {
  bucket        = local.s3_logging_bucket_name
  force_destroy = true
  tags          = local.tags
}

resource "aws_s3_bucket_policy" "logging" {
  bucket = aws_s3_bucket.logging.id
  policy = data.aws_iam_policy_document.logging.json
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logging.arn
      sse_algorithm     = "aws:kms:dsse"
    }
  }
}
