variable "internal" {
  type        = bool
  description = "Flag to determine if the several AWS resources are public (intended for external access, public internet) or private (only intended to be accessed within your AWS VPC or avaiable with other means, a transit gateway for example)."
  default     = true
}

variable "alb_idle_timeout" {
  type        = number
  description = "The idle timeout value in seconds for the Application Load Balancer (ALB)"
  default     = 900
}

variable "appmesh_name" {
  type        = string
  description = "Name of the AWS App Mesh"
  default     = ""
}

variable "cloudmap_namespace_name" {
  type        = string
  description = "Name of the AWS Cloud Map namespace"
  default     = ""
}

variable "cw_retention_in_days" {
  type        = number
  description = "Retention period in days for CloudWatch logs"
  default     = 365
}

variable "ecs_alb_name" {
  description = "Name of the Application Load Balancer (ALB)"
  type        = string
  default     = ""
}

variable "ecs_alb_tg_name" {
  description = "Name of the ALB Target Group"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
  default     = ""
}

variable "ecs_cloudwatch_group" {
  type        = string
  description = "Name of the AWS CloudWatch Log Group for ECS"
  default     = ""
}

variable "ecs_task_execution_role_name" {
  type        = string
  description = "Name of the ECS Task Execution Role"
  default     = ""
}

variable "ecs_task_role_name" {
  type        = string
  description = "Name of the ECS Task Role"
  default     = ""
}

variable "enable_autoscaling" {
  type        = bool
  description = "Flag to enable autoscaling for the ECS services"
  default     = true
}

variable "enable_alb_logs" {
  type        = bool
  description = "Flag to enable ALB access and connection logging to s3 logging bucket"
  default     = true
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "region" {
  type        = string
  description = "The AWS region where resources are created"
}

variable "s3_viewer_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for the viewer"
  default     = ""
}

variable "s3_viewer_bucket_role_name" {
  type        = string
  description = "Name of the IAM role for the ecr-viewer bucket"
  default     = ""
}

variable "s3_logging_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for logging"
  default     = ""
}
variable "phdi_version" {
  type        = string
  description = "Version of the PHDI application"
  default     = "v2.0.0-beta"
}

variable "service_data" {
  type = map(object({
    short_name        = string
    app_repo          = string
    app_image         = string
    app_version       = string
    container_port    = number
    host_port         = number
    public            = bool
    registry_url      = string
    root_service      = bool
    listener_priority = number
    env_vars = list(object({
      name  = string
      value = string
    }))
  }))
  description = "Data for the DIBBS services"
  default     = {}
}

variable "override_autoscaling" {
  type = map(object({
    cpu           = number
    memory        = number
    min_capacity  = number
    max_capacity  = number
    target_cpu    = number
    target_memory = number
  }))
  description = "Autoscaling configuration for the DIBBS services"
  default     = {}
}

variable "secrets_manager_connection_string_version" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secrets_manager_sqlserver_user_version" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secrets_manager_sqlserver_password_version" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secrets_manager_sqlserver_host_version" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secrets_manager_metadata_database_migration_secret_version" {
  type      = string
  default   = ""
  sensitive = true
}

variable "auth_provider" {
  type        = string
  default     = ""
  description = "The authentication provider used. Either keycloak or ad."
}

variable "auth_client_id" {
  type        = string
  default     = ""
  description = "The application/client id used to idenitfy the client"
}

variable "auth_issuer" {
  type        = string
  default     = ""
  description = "Additional information used during authentication process. For Azure AD, this will be the 'Tenant Id'. For Keycloak, this will be the url issuer including the realm - e.g. https://my-keycloak-domain.com/realms/My_Realm"
}

variable "auth_url" {
  type        = string
  default     = ""
  description = "Optional. The full URL of the auth api. By default https://your-site.com/ecr-viewer/api/auth."
}

variable "auth_session_duration_min" {
  type        = string
  default     = ""
  description = "Duration in minutes before auto signout, defaults to 30 if not set"
}

variable "secrets_manager_auth_secret_version" {
  type        = string
  default     = ""
  description = "The secret containing the auth secret. This is used by eCR viewer to encrypt authentication. This can be generated by running `openssl rand -base64 32`."
  sensitive   = true
}

variable "secrets_manager_auth_client_secret_version" {
  type        = string
  default     = ""
  description = "The secret containing the auth client secret. This is the secret that comes from the authentication provider."
  sensitive   = true
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate that enables ssl termination on the ALB"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "owner" {
  type        = string
  description = "Owner of the resources"
  default     = "CDC"
}

variable "project" {
  type        = string
  description = "The project name"
  default     = "dibbs"
}

variable "disable_ecr" {
  type        = bool
  description = "Flag to disable the aws ecr service for docker image storage, defaults to false"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "ecr_viewer_auth_pub_key" {
  type        = string
  description = "The public key used to validate the incoming authenication for the eCR Viewer."
  default     = ""
}

variable "ecr_viewer_auth_api_pub_key" {
  type        = string
  description = "The public key used to validate the incoming authenication for the eCR Viewer API."
  default     = ""
}

variable "dibbs_config_name" {
  type        = string
  description = "Name of the DIBBS configuration"
  default     = ""
}

variable "dibbs_repo" {
  type        = string
  description = "Name of the DIBBS repository"
  default     = "ghcr.io/cdcgov/dibbs-ecr-viewer"
}

variable "db_cipher" {
  type        = string
  description = "The cipher to use for the sql server database connection"
  default     = ""
}

variable "ecr_viewer_object_retention_days" {
  type        = number
  description = "Number of days to retain S3 ecr viewer objects in compliance mode"
  default     = 3650
}

variable "logging_object_retention_days" {
  type        = number
  description = "Number of days to retain S3 logging objects in compliance mode"
  default     = 90
}
