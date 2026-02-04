resource "aws_cloudwatch_log_group" "ecs_cloudwatch_logging" {
  name              = local.ecs_cloudwatch_group
  retention_in_days = var.cw_retention_in_days
  kms_key_id        = aws_kms_key.logging.arn
  tags              = local.tags
}

resource "aws_flow_log" "ecs_flow_log" {
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.ecs_task_execution.arn
  traffic_type         = "ALL"
  log_destination      = aws_cloudwatch_log_group.ecs_cloudwatch_logging.arn
  log_destination_type = "cloud-watch-logs"
  tags                 = local.tags
}
