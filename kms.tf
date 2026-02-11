resource "aws_kms_key" "ecr_viewer" {
  enable_key_rotation = true
}

resource "aws_kms_key_policy" "ecr_viewer" {
  key_id = aws_kms_key.ecr_viewer.key_id
  policy = data.aws_iam_policy_document.kms.json
}
