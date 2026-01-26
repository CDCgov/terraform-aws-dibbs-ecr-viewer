# WAF Configuration for Application Load Balancer
# This module ensures compliance with NIST security issue [ELB.16]
# which requires Application Load Balancers to be associated with an AWS WAF web ACL
# with the Enabled field set to true.

# Create WAF Web ACL if not provided
resource "aws_wafv2_web_acl" "this" {
  count = var.waf_web_acl_arn == "" ? 1 : 0

  name  = "${local.ecs_alb_name}-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "waf-block-ipset"
    priority = 0
    action {
      block {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.block.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-block-ipset"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = toset(local.waf_rules)
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
        none {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name
          dynamic "managed_rule_group_configs" {
            for_each = rule.value.name == "AWSManagedRulesBotControlRuleSet" ? [1] : []
            content {
              aws_managed_rules_bot_control_rule_set {
                inspection_level = "COMMON"
              }
            }
          }
          dynamic "rule_action_override" {
            for_each = rule.value.allow
            content {
              name = rule_action_override.value
              action_to_use {
                allow {}
              }
            }
          }
          dynamic "rule_action_override" {
            for_each = rule.value.block
            content {
              name = rule_action_override.value
              action_to_use {
                block {}
              }
            }
          }
          dynamic "rule_action_override" {
            for_each = rule.value.count
            content {
              name = rule_action_override.value
              action_to_use {
                count {}
              }
            }
          }
          dynamic "rule_action_override" {
            for_each = rule.value.challenge
            content {
              name = rule_action_override.value
              action_to_use {
                challenge {}
              }
            }
          }
          dynamic "rule_action_override" {
            for_each = rule.value.captcha
            content {
              name = rule_action_override.value
              action_to_use {
                captcha {}
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.ecs_alb_name}-waf-metrics"
    sampled_requests_enabled   = true
  }
  tags = local.tags
}

resource "aws_wafv2_web_acl_association" "this" {
  count        = var.waf_web_acl_arn == "" ? 1 : 0
  resource_arn = aws_alb.ecs.id
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}


resource "aws_wafv2_web_acl_association" "external_waf" {
  count        = var.waf_web_acl_arn != "" ? 1 : 0
  resource_arn = aws_alb.ecs.id
  web_acl_arn  = var.waf_web_acl_arn
}

resource "aws_wafv2_ip_set" "block" {
  name               = "waf-${local.ecs_alb_name}-block-ipset-alb"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.block_ip_set
}
