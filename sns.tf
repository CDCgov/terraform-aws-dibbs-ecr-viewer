resource "aws_sns_topic" "ecr_viewer" {
  name   = "${local.s3_viewer_bucket_name}-notifications"
  policy = data.aws_iam_policy_document.ecr_viewer_sns.json
  # kms_master_key_id = aws_kms_key.ecr_viewer.arn
}
