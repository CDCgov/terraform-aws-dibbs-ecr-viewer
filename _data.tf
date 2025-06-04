data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "elb_account_id" {}

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
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [
      aws_s3_bucket.ecr_viewer.arn,
      "${aws_s3_bucket.ecr_viewer.arn}/*",
      aws_kms_key.ecr_viewer.arn,
      "${aws_kms_key.ecr_viewer.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "logging" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/access-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/connection-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_elb_service_account.elb_account_id.id}:root"]
    }
  }
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/access-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/connection-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}",
    ]
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
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
