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
