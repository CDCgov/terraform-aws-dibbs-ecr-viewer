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
  count     = local.database_data.metadata_database_type == "postgres" ? 1 : 0
  secret_id = local.database_data.metadata_database_type == "postgres" ? local.database_data.secrets_manager_postgres_database_url_name : ""
}

data "aws_secretsmanager_secret_version" "sqlserver_user" {
  count     = local.database_data.metadata_database_type == "sqlserver" ? 1 : 0
  secret_id = local.database_data.metadata_database_type == "sqlserver" ? local.database_data.secrets_manager_sqlserver_user_name : ""
}

data "aws_secretsmanager_secret_version" "sqlserver_password" {
  count     = local.database_data.metadata_database_type == "sqlserver" ? 1 : 0
  secret_id = local.database_data.metadata_database_type == "sqlserver" ? local.database_data.secrets_manager_sqlserver_password_name : ""
}

data "aws_secretsmanager_secret_version" "sqlserver_host" {
  count     = local.database_data.metadata_database_type == "sqlserver" ? 1 : 0
  secret_id = local.database_data.metadata_database_type == "sqlserver" ? local.database_data.secrets_manager_sqlserver_host_name : ""
}
