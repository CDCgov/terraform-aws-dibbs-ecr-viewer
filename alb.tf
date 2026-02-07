resource "aws_alb" "ecs" {
  name                       = local.ecs_alb_name
  internal                   = var.internal
  load_balancer_type         = "application"
  subnets                    = var.internal == true ? flatten([var.private_subnet_ids]) : flatten([var.public_subnet_ids])
  security_groups            = [aws_security_group.alb.id]
  drop_invalid_header_fields = true

  enable_deletion_protection = var.enable_alb_deletion_protection

  idle_timeout = var.alb_idle_timeout
  access_logs {
    enabled = var.enable_alb_logs
    bucket  = aws_s3_bucket.logging.id
  }

  connection_logs {
    enabled = var.enable_alb_logs
    bucket  = aws_s3_bucket.logging.id
  }

  depends_on = [aws_s3_bucket_policy.logging, aws_s3_bucket.logging]
  tags       = local.tags
}

resource "aws_alb_target_group" "this" {
  for_each = {
    for key, value in local.service_data : key => value
    if local.service_data[key].public == true
  }
  name        = "${local.ecs_alb_tg_name}-${each.value.short_name}"
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "120"
    protocol            = "HTTP"
    matcher             = "200-499"
    timeout             = "3"
    path                = "/${each.key}"
    unhealthy_threshold = "3"
  }
  tags = local.tags
}

resource "aws_vpc_endpoint" "endpoints" {
  count               = var.internal == true ? length(local.vpc_endpoints) : 0
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  service_name        = local.vpc_endpoints[count.index]
  security_group_ids  = [aws_security_group.ecs.id]
  subnet_ids          = flatten([var.private_subnet_ids])
  tags                = local.tags
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.internal == true ? 1 : 0
  vpc_id            = var.vpc_id
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in data.aws_route_table.this : rt.id]
  service_name      = local.s3_service_name
  tags              = local.tags
}

# The aws_alb_listener and aws_alb_listener_rule resources are not depended on by other resources so
# they can be implemented via a loop or hard coded depending ease of maintenance
# I've chosen the ways that reduce duplicated resource blocks: hard coded listener (i.e. http), looped listener rule (i.e. this)

# We may want to create this resource via a loop through our target groups but at the moment that seemed extra

# https://avd.aquasec.com/misconfig/aws/elb/avd-aws-0054/
# trivy:ignore:AVD-AWS-0054
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.ecs.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = local.tags
}

# We may want to create this resource without the loop if the path_patterns ever break the pattern of being the name of the service
resource "aws_alb_listener_rule" "http" {
  for_each = {
    for key, value in aws_alb_target_group.this : key => value
    if local.service_data[key].public == true
  }
  listener_arn = aws_alb_listener.http.arn
  priority     = local.service_data[each.key].listener_priority

  dynamic "action" {
    for_each = var.certificate_arn != "" ? [] : [each.value]
    content {
      type             = "forward"
      target_group_arn = each.value.arn
      # terraform will complain that we have a redirect action and a forward action but the issue disappears on a subsequent apply
    }
  }

  dynamic "action" {
    for_each = var.certificate_arn != "" ? [each.value] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  condition {
    path_pattern {
      values = local.service_data[each.key].root_service == true ? [
        "/",
        "/*"
        ] : [
        "/${each.key}",
        "/${each.key}/*"
      ]
    }
  }
  lifecycle {
    replace_triggered_by = [
      null_resource.target_groups
    ]
  }
  tags = local.tags
}

resource "aws_alb_listener" "https" {
  count             = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_alb.ecs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "I care intently about your request but I'm afraid I don't have anything for you right now."
      status_code  = "404"
    }
  }

  tags = local.tags
}

# We may want to create this resource without the loop if the path_patterns ever break the pattern of being the name of the service
resource "aws_alb_listener_rule" "https" {
  for_each = {
    for key, value in local.service_data : key => value
    if value.public == true && var.certificate_arn != ""
  }
  listener_arn = aws_alb_listener.https[0].arn
  priority     = local.service_data[each.key].listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = local.service_data[each.key].root_service == true ? [
        "/",
        "/*"
        ] : [
        "/${each.key}",
        "/${each.key}/*"
      ]
    }
  }
  lifecycle {
    replace_triggered_by = [
      null_resource.target_groups
    ]
  }
  tags = local.tags
}

resource "null_resource" "target_groups" {
  for_each = aws_alb_target_group.this
  triggers = {
    target_group = each.value.id
  }
}

resource "aws_security_group" "ecs" {
  vpc_id                 = var.vpc_id
  name                   = "${local.ecs_cluster_name}-ecs"
  description            = "Security group for ECS"
  revoke_rules_on_delete = true
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

# ECS Security Group Rules - INBOUND
resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ALB"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.alb.id
}

# ECS Security Group Rules - INBOUND
resource "aws_security_group_rule" "ecs_ecs_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ECS"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
}

# ECS Security Group Rules - OUTBOUND
# https://avd.aquasec.com/misconfig/aws/ec2/avd-aws-0104/
# trivy:ignore:AVD-AWS-0104
resource "aws_security_group_rule" "ecs_egress" {
  # checkov:skip=CKV_AWS_382:ECS_EGRESS_RULES
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security Group for alb
resource "aws_security_group" "alb" {
  vpc_id                 = var.vpc_id
  name                   = "${local.ecs_alb_name}-alb"
  description            = "Security group for ALB"
  revoke_rules_on_delete = true
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow https inbound traffic from internet"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Alb Security Group Rules - OUTBOUND
# https://avd.aquasec.com/misconfig/aws/ec2/avd-aws-0104/
# trivy:ignore:AVD-AWS-0104
resource "aws_security_group_rule" "alb_egress" {
  # checkov:skip=CKV_AWS_382:ALB_EGRESS_RULES
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from alb"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}