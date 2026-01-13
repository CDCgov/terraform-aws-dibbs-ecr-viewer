terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.0"
    }
    dockerless = {
      source  = "nullstone-io/dockerless"
      version = "~> 0.1.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
  required_version = "~> 1.9.0"
}

provider "dockerless" {
  registry_auth = {
    "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com" = {
      username = local.registry_username
      password = local.registry_password
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = tags
  }
}

provider "aws" {
  alias  = "replication"
  region = var.replication_region
  default_tags {
    tags = tags
  }
}