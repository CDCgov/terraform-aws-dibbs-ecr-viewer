resource "dockerless_remote_image" "dibbs" {
  for_each = var.disable_ecr == false ? local.service_data : {}
  source   = "${each.value.app_repo}/${each.key}:${each.value.app_version}"
  target   = "${each.value.registry_url}/${each.value.app_image}:${each.value.app_version}"
}

data "aws_ecr_authorization_token" "this" {}

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
