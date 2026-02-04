data "aws_ecr_authorization_token" "this" {}

data "aws_ecr_lifecycle_policy_document" "this" {
  rule {
    priority    = 1
    description = "Keep last 10 images"

    selection {
      tag_status       = "tagged"
      tag_pattern_list = ["*"]
      count_type       = "imageCountMoreThan"
      count_number     = 10
    }
  }
}

resource "aws_kms_key" "ecr" {
  enable_key_rotation = true
  tags                = local.tags

  # Allow ECR service to use this key for encryption
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = true
          }
        }
      }
    ]
  })
}

resource "dockerless_remote_image" "dibbs" {
  for_each = var.disable_ecr == false ? local.service_data : {}
  source   = "${each.value.app_repo}/${each.key}:${each.value.app_version}"
  target   = "${each.value.registry_url}/${each.value.app_image}:${each.value.app_version}"
}

resource "aws_ecr_repository" "this" {
  for_each             = var.disable_ecr == false ? local.service_data : {}
  name                 = each.value.app_image
  force_delete         = true
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = var.disable_ecr == false ? local.service_data : {}
  repository = aws_ecr_repository.this[each.key].name

  policy = data.aws_ecr_lifecycle_policy_document.this.json
}
