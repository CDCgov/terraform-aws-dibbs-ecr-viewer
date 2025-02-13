resource "random_string" "s3_viewer" {
  length  = 8
  special = false
  upper   = false
}

locals {
  registry_url      = var.disable_ecr == false ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com" : "ghcr.io/cdcgov/dibbs-ecr-viewer"
  registry_username = data.aws_ecr_authorization_token.this.user_name
  registry_password = data.aws_ecr_authorization_token.this.password
  phdi_repo         = "ghcr.io/cdcgov/dibbs-ecr-viewer"
  database_url = data.aws_secretsmanager_secret_version.postgres_database_url != "" ? {
    name  = "DATABASE_URL",
    value = data.aws_secretsmanager_secret_version.postgres_database_url.secret_string
    } : {
    name  = "BLANK_DATABASE_URL",
    value = ""
  }
  sqlserver_user = data.aws_secretsmanager_secret_version.sqlserver_user != "" ? {
    name  = "SQL_SERVER_USER",
    value = data.aws_secretsmanager_secret_version.sqlserver_user.secret_string
    } : {
    name  = "BLANK_SQL_SERVER_USER",
    value = ""
  }
  sqlserver_password = data.aws_secretsmanager_secret_version.sqlserver_password != "" ? {
    name  = "SQL_SERVER_PASSWORD",
    value = data.aws_secretsmanager_secret_version.sqlserver_password.secret_string
    } : {
    name  = "BLANK_SQL_SERVER_PASSWORD",
    value = ""
  }
  sqlserver_host = data.aws_secretsmanager_secret_version.sqlserver_host != "" ? {
    name  = "SQL_SERVER_HOST",
    value = data.aws_secretsmanager_secret_version.sqlserver_host.secret_string
    } : {
    name  = "BLANK_SQL_SERVER_HOST",
    value = ""
  }

  service_data = length(var.service_data) > 0 ? var.service_data : {
    ecr-viewer = {
      short_name        = "ecrv",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-ecr-viewer" : "ecr-viewer",
      app_version       = var.phdi_version,
      container_port    = 3000,
      host_port         = 3000,
      public            = true,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 2
      env_vars = [
        {
          name  = "AWS_REGION",
          value = var.region
        },
        {
          name  = "ECR_BUCKET_NAME",
          value = local.s3_viewer_bucket_name
        },
        {
          name  = "HOSTNAME",
          value = "0.0.0.0"
        },
        {
          name  = "NBS_AUTH",
          value = var.nbs_auth
        },
        {
          name  = "CONFIG_NAME",
          value = var.dibbs_config_name
        },
        {
          name  = "NBS_PUB_KEY",
          value = var.ecr_viewer_auth_pub_key
        },
        local.database_url,
        local.sqlserver_user,
        local.sqlserver_password,
        local.sqlserver_host
      ]
    },
    fhir-converter = {
      short_name        = "fhirc",
      fargate_cpu       = 1024,
      fargate_memory    = 2048,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-fhir-converter" : "fhir-converter",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = false,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 50000
      env_vars          = []
    },
    ingestion = {
      short_name        = "inge",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-ingestion" : "ingestion",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = false,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 50000
      env_vars          = []
    },
    validation = {
      short_name        = "vali",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-validation" : "validation",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = false,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 50000
      env_vars          = []
    },
    trigger-code-reference = {
      short_name        = "trigcr",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-trigger-code-reference" : "trigger-code-reference",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = false,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 50000
      env_vars          = []
    },
    message-parser = {
      short_name        = "msgp",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-message-parser" : "message-parser",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = false
      registry_url      = local.registry_url
      root_service      = false,
      listener_priority = 50000
      env_vars          = []
    },
    orchestration = {
      short_name        = "orch",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.phdi_repo,
      app_image         = var.disable_ecr == false ? "${terraform.workspace}-orchestration" : "orchestration",
      app_version       = var.phdi_version,
      container_port    = 8080,
      host_port         = 8080,
      public            = true,
      registry_url      = local.registry_url,
      root_service      = false,
      listener_priority = 1
      env_vars = [
        {
          name  = "OTEL_METRICS",
          value = "none"
        },
        {
          name  = "OTEL_METRICS_EXPORTER",
          value = "none"
        },
        {
          name  = "INGESTION_URL",
          value = "http://ingestion:8080"
        },
        {
          name  = "VALIDATION_URL",
          value = "http://validation:8080"
        },
        {
          name  = "FHIR_CONVERTER_URL",
          value = "http://fhir-converter:8080"
        },
        {
          name  = "ECR_VIEWER_URL",
          value = "http://ecr-viewer:3000/ecr-viewer"
        },
        {
          name  = "MESSAGE_PARSER_URL",
          value = "http://message-parser:8080"
        },
        {
          name  = "TRIGGER_CODE_REFERENCE_URL",
          value = "http://trigger-code-reference:8080"
        }
      ]
    }
  }
  local_name = "${var.project}-${var.owner}-${terraform.workspace}"

  appmesh_name                 = var.appmesh_name == "" ? local.local_name : var.appmesh_name
  cloudmap_namespace_name      = var.cloudmap_namespace_name == "" ? local.local_name : var.cloudmap_namespace_name
  ecs_alb_name                 = var.ecs_alb_name == "" ? local.local_name : var.ecs_alb_name
  ecs_alb_tg_name              = var.ecs_alb_tg_name == "" ? local.local_name : var.ecs_alb_tg_name
  ecs_task_execution_role_name = var.ecs_task_execution_role_name == "" ? "${local.local_name}-tern" : var.ecs_task_execution_role_name
  ecs_task_role_name           = var.ecs_task_role_name == "" ? "${local.local_name}-trn" : var.ecs_task_role_name
  ecs_cloudwatch_group         = var.ecs_cloudwatch_group == "" ? "/${local.local_name}" : var.ecs_cloudwatch_group
  ecs_cluster_name             = var.ecs_cluster_name == "" ? local.local_name : var.ecs_cluster_name
  s3_viewer_bucket_name        = var.s3_viewer_bucket_name == "" ? "${local.local_name}-${random_string.s3_viewer.result}" : var.s3_viewer_bucket_name
  s3_viewer_bucket_role_name   = var.s3_viewer_bucket_role_name == "" ? "${local.local_name}-ecrv" : var.s3_viewer_bucket_role_name
  tags                         = var.tags
  vpc_endpoints = [
    "com.amazonaws.${var.region}.ecr.dkr",
    "com.amazonaws.${var.region}.ecr.api",
    "com.amazonaws.${var.region}.ecs",
    "com.amazonaws.${var.region}.ecs-telemetry",
    "com.amazonaws.${var.region}.logs",
    "com.amazonaws.${var.region}.secretsmanager",
  ]
  s3_service_name    = "com.amazonaws.${var.region}.s3"
  private_subnet_kvs = { for index, rt in var.private_subnet_ids : index => rt }
}
