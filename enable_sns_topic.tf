resource "aws_sns_topic" "ecr_viewer" {
  count             = var.enable_ecr_viewer_sns_topic ? 1 : 0
  name              = local.s3_viewer_bucket_name
  kms_master_key_id = aws_kms_key.ecr_viewer.arn
}

resource "aws_s3_bucket_notification" "ecr_viewer" {
  count  = var.enable_ecr_viewer_sns_topic ? 1 : 0
  bucket = aws_s3_bucket.ecr_viewer.id
  topic {
    topic_arn = aws_sns_topic.ecr_viewer[0].arn
    events    = var.ecr_viewer_bucket_sns_topic_events
  }
  depends_on = [aws_sns_topic_policy.ecr_viewer[0]]
}

resource "aws_sns_topic_policy" "ecr_viewer" {
  count  = var.enable_ecr_viewer_sns_topic ? 1 : 0
  arn    = aws_sns_topic.ecr_viewer[0].arn
  policy = data.aws_iam_policy_document.ecr_viewer[0].json
}

data "aws_iam_policy_document" "ecr_viewer" {
  count = var.enable_ecr_viewer_sns_topic ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.ecr_viewer[0].arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.ecr_viewer.arn]
    }
  }
}

# logging
resource "aws_sns_topic" "logging" {
  count             = var.enable_logging_sns_topic ? 1 : 0
  name              = local.s3_logging_bucket_name
  kms_master_key_id = aws_kms_key.ecr_viewer.arn
}

resource "aws_s3_bucket_notification" "logging" {
  count  = var.enable_logging_sns_topic ? 1 : 0
  bucket = aws_s3_bucket.logging.id
  topic {
    topic_arn = aws_sns_topic.logging[0].arn
    events    = var.logging_bucket_sns_topic_events
  }
  depends_on = [aws_sns_topic_policy.logging[0]]
}

resource "aws_sns_topic_policy" "logging" {
  count  = var.enable_logging_sns_topic ? 1 : 0
  arn    = aws_sns_topic.logging[0].arn
  policy = data.aws_iam_policy_document.logging[0].json
}

data "aws_iam_policy_document" "logging" {
  count = var.enable_logging_sns_topic ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.logging[0].arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.logging.arn]
    }
  }
}