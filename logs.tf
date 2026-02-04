resource "aws_kms_key" "cloudwatch" {
  enable_key_rotation = true
  tags                = local.tags

  # Allow CloudWatch service to use this key for encryption
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "ecs_cloudwatch_logs" {
  name              = local.ecs_cloudwatch_group
  retention_in_days = var.cw_retention_in_days
  kms_key_id        = aws_kms_key.cloudwatch.arn
  tags              = local.tags
}

resource "aws_flow_log" "ecs_flow_log" {
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.ecs_task_execution.arn
  traffic_type         = "ALL"
  log_destination      = aws_cloudwatch_log_group.ecs_cloudwatch_logs.arn
  log_destination_type = "cloud-watch-logs"
  tags                 = local.tags
}
