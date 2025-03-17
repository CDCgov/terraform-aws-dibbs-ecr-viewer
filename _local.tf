resource "random_string" "s3_viewer" {
  length  = 8
  special = false
  upper   = false
}

locals {
  registry_url      = var.disable_ecr == false ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com" : var.dibbs_repo
  registry_username = data.aws_ecr_authorization_token.this.user_name
  registry_password = data.aws_ecr_authorization_token.this.password
  dibbs_repo        = var.dibbs_repo
  database_url = var.database_type == "postgresql" ? {
    name  = "DATABASE_URL",
    value = var.secrets_manager_postgresql_connection_string_version
  } : null
  sqlserver_user = var.database_type == "sqlserver" ? {
    name  = "SQL_SERVER_USER",
    value = var.secrets_manager_sqlserver_user_version
  } : null
  sqlserver_password = var.database_type == "sqlserver" ? {
    name  = "SQL_SERVER_PASSWORD",
    value = var.secrets_manager_sqlserver_password_version
  } : null
  sqlserver_host = var.database_type == "sqlserver" ? {
    name  = "SQL_SERVER_HOST",
    value = var.secrets_manager_sqlserver_host_version
  } : null
  db_cipher = var.database_type == "sqlserver" ? {
    name  = "DB_CIPHER",
    value = var.db_cipher
  } : null
  auth_provider      = var.auth_provider != "" ? { name = "AUTH_PROVIDER", value = var.auth_provider } : null
  auth_client_id     = var.auth_client_id != "" ? { name = "AUTH_CLIENT_ID", value = var.auth_client_id } : null
  auth_client_secret = var.secrets_manager_auth_client_secret != "" ? { name = "AUTH_CLIENT_SECRET", value = var.secrets_manager_auth_client_secret } : null
  auth_issuer        = var.auth_issuer != "" ? { name = "AUTH_ISSUER", value = var.auth_issuer } : null
  auth_url           = var.auth_url != "" ? { name = "NEXTAUTH_URL", value = var.auth_url } : null
  auth_secret        = var.secrets_manager_auth_secret != "" ? { name = "NEXTAUTH_SECRET", value = var.secrets_manager_auth_secret } : null
  service_data = length(var.service_data) > 0 ? var.service_data : {
    ecr-viewer = {
      short_name        = "ecrv",
      fargate_cpu       = 512,
      fargate_memory    = 1024,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.dibbs_repo,
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
        local.sqlserver_host,
        local.db_cipher,
        local.auth_provider,
        local.auth_client_id,
        local.auth_client_secret,
        local.auth_issuer,
        local.auth_url,
        local.auth_secret
      ]
    },
    fhir-converter = {
      short_name        = "fhirc",
      fargate_cpu       = 1024,
      fargate_memory    = 2048,
      min_capacity      = 1,
      max_capacity      = 5,
      app_repo          = local.dibbs_repo,
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
      app_repo          = local.dibbs_repo,
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
      app_repo          = local.dibbs_repo,
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
      app_repo          = local.dibbs_repo,
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
      app_repo          = local.dibbs_repo,
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
      app_repo          = local.dibbs_repo,
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
