# task execution role
resource "aws_iam_role" "ecs_task_execution" {
  name               = local.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# task role
resource "aws_iam_role" "ecs_task" {
  name               = local.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_amazon_ec2_container_service_for_ec2_role" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = data.aws_iam_policy.amazon_ec2_container_service_for_ec2_role.arn
}

# s3
resource "aws_iam_role" "s3_role_for_ecr_viewer" {
  name               = local.s3_viewer_bucket_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "s3_bucket_ecr_viewer" {
  name        = "${local.s3_viewer_bucket_role_name}-policy"
  description = "Policy for eCR-Viewer policy"
  policy      = data.aws_iam_policy_document.ecr_viewer_s3.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "s3_role_for_ecr_viewer_s3_bucket_ecr_viewer" {
  role       = aws_iam_role.s3_role_for_ecr_viewer.name
  policy_arn = aws_iam_policy.s3_bucket_ecr_viewer.arn
}

resource "aws_iam_role_policy_attachment" "s3_role_for_ecr_viewer_amazon_ec2_container_service_for_ec2_role" {
  role       = aws_iam_role.s3_role_for_ecr_viewer.name
  policy_arn = data.aws_iam_policy.amazon_ec2_container_service_for_ec2_role.arn
}