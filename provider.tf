terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
    dockerless = {
      source  = "nullstone-io/dockerless"
      version = "0.1.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
  required_version = "1.9.8"
}

provider "dockerless" {
  registry_auth = {
    "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com" = {
      username = local.registry_username
      password = local.registry_password
    }
  }
}
