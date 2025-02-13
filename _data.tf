data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_viewer_s3" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.ecr_viewer.arn,
      "${aws_s3_bucket.ecr_viewer.arn}/*",
    ]
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "amazon_ec2_container_service_for_ec2_role" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

data "aws_route_table" "this" {
  for_each  = local.private_subnet_kvs
  subnet_id = each.value
}

data "aws_secretsmanager_secret_version" "postgres_database_url" {
  # count     = var.secrets_manager_postgresql_connection_string_name == "" ? 0 : 1
  secret_id = var.secrets_manager_postgresql_connection_string_name
}

data "aws_secretsmanager_secret_version" "sqlserver_user" {
  # count     = var.secrets_manager_sqlserver_user_name == "" ? 0 : 1
  secret_id = var.secrets_manager_sqlserver_user_name
}

data "aws_secretsmanager_secret_version" "sqlserver_password" {
  # count     = var.secrets_manager_sqlserver_password_name == "" ? 0 : 1
  secret_id = var.secrets_manager_sqlserver_password_name
}

data "aws_secretsmanager_secret_version" "sqlserver_host" {
  # count     = var.secrets_manager_sqlserver_host_name == "" ? 0 : 1
  secret_id = var.secrets_manager_sqlserver_host_name
}
