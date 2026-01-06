resource "aws_iam_role" "s3_replication" {
  name = local.s3_viewer_replication_bucket_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# task execution role
resource "aws_iam_role" "ecs_task_execution" {
  name = local.ecs_task_execution_role_name
  managed_policy_arns = [
    data.aws_iam_policy.ecs_task_execution.arn
  ]
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

# task role
resource "aws_iam_role" "ecs_task" {
  name = local.ecs_task_role_name
  managed_policy_arns = [
    data.aws_iam_policy.amazon_ec2_container_service_for_ec2_role.arn
  ]
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

# s3
resource "aws_iam_role" "s3_role_for_ecr_viewer" {
  name = local.s3_viewer_bucket_role_name
  managed_policy_arns = [
    data.aws_iam_policy.amazon_ec2_container_service_for_ec2_role.arn,
    aws_iam_policy.s3_bucket_ecr_viewer.arn
  ]
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "s3_replication" {
  role       = data.aws_iam_role.s3_replication.name
  policy_arn = data.aws_iam_policy.s3_replication.arn
}

resource "aws_iam_policy" "s3_bucket_ecr_viewer" {
  name        = "${local.s3_viewer_bucket_role_name}-policy"
  description = "Policy for ECR-Viewer and S3 for DIBBS-AWS"
  policy      = data.aws_iam_policy_document.ecr_viewer_s3.json
  tags        = local.tags
}
