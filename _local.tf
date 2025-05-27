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
  database_url = var.secrets_manager_connection_string_version != "" ? {
    name  = "DATABASE_URL",
    value = var.secrets_manager_connection_string_version
  } : null
  sqlserver_user = var.secrets_manager_sqlserver_user_version != "" ? {
    name  = "SQL_SERVER_USER",
    value = var.secrets_manager_sqlserver_user_version
  } : null
  sqlserver_password = var.secrets_manager_sqlserver_password_version != "" ? {
    name  = "SQL_SERVER_PASSWORD",
    value = var.secrets_manager_sqlserver_password_version
  } : null
  sqlserver_host = var.secrets_manager_sqlserver_host_version != "" ? {
    name  = "SQL_SERVER_HOST",
    value = var.secrets_manager_sqlserver_host_version
  } : null
  db_cipher = var.db_cipher != "" ? {
    name  = "DB_CIPHER",
    value = var.db_cipher
  } : null
  auth_provider      = var.auth_provider != "" ? { name = "AUTH_PROVIDER", value = var.auth_provider } : null
  auth_client_id     = var.auth_client_id != "" ? { name = "AUTH_CLIENT_ID", value = var.auth_client_id } : null
  auth_client_secret = var.secrets_manager_auth_client_secret_version != "" ? { name = "AUTH_CLIENT_SECRET", value = var.secrets_manager_auth_client_secret_version } : null
  auth_issuer        = var.auth_issuer != "" ? { name = "AUTH_ISSUER", value = var.auth_issuer } : null
  auth_url           = var.auth_url != "" ? { name = "NEXTAUTH_URL", value = var.auth_url } : null
  auth_secret        = var.secrets_manager_auth_secret_version != "" ? { name = "NEXTAUTH_SECRET", value = var.secrets_manager_auth_secret_version } : null
  override_autoscaling = {
    ecr-viewer = {
      cpu           = try(var.override_autoscaling["ecr-viewer"].cpu, 512),
      memory        = try(var.override_autoscaling["ecr-viewer"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["ecr-viewer"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["ecr-viewer"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["ecr-viewer"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["ecr-viewer"].target_memory, 80)
    },
    fhir-converter = {
      cpu           = try(var.override_autoscaling["fhir-converter"].cpu, 512),
      memory        = try(var.override_autoscaling["fhir-converter"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["fhir-converter"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["fhir-converter"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["fhir-converter"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["fhir-converter"].target_memory, 80)
    },
    ingestion = {
      cpu           = try(var.override_autoscaling["ingestion"].cpu, 512),
      memory        = try(var.override_autoscaling["ingestion"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["ingestion"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["ingestion"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["ingestion"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["ingestion"].target_memory, 80)
    },
    validation = {
      cpu           = try(var.override_autoscaling["validation"].cpu, 512),
      memory        = try(var.override_autoscaling["validation"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["validation"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["validation"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["validation"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["validation"].target_memory, 80)
    },
    trigger-code-reference = {
      cpu           = try(var.override_autoscaling["trigger-code-reference"].cpu, 512),
      memory        = try(var.override_autoscaling["trigger-code-reference"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["trigger-code-reference"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["trigger-code-reference"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["trigger-code-reference"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["trigger-code-reference"].target_memory, 80)
    },
    message-parser = {
      cpu           = try(var.override_autoscaling["message-parser"].cpu, 512),
      memory        = try(var.override_autoscaling["message-parser"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["message-parser"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["message-parser"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["message-parser"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["message-parser"].target_memory, 80)
    },
    orchestration = {
      cpu           = try(var.override_autoscaling["orchestration"].cpu, 512),
      memory        = try(var.override_autoscaling["orchestration"].memory, 1024),
      min_capacity  = try(var.override_autoscaling["orchestration"].min_capacity, 1),
      max_capacity  = try(var.override_autoscaling["orchestration"].max_capacity, 5),
      target_cpu    = try(var.override_autoscaling["orchestration"].target_cpu, 50),
      target_memory = try(var.override_autoscaling["orchestration"].target_memory, 80)
    }
  }
  service_data = length(var.service_data) > 0 ? var.service_data : {
    ecr-viewer = {
      short_name        = "ecrv",
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
        {
          name  = "NBS_API_PUB_KEY",
          value = var.ecr_viewer_auth_api_pub_key
        },
        {
          name  = "ORCHESTRATION_URL",
          value = "http://orchestration:8080"
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
  s3_logging_bucket_name       = var.s3_logging_bucket_name == "" ? "${local.local_name}-${random_string.s3_viewer.result}-logging" : var.s3_logging_bucket_name
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
