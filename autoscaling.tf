

resource "aws_appautoscaling_target" "this" {
    for_each = var.enable_autoscaling ? aws_ecs_service.this : {}
  max_capacity = local.service_data[each.key].max_capacity
    min_capacity = local.service_data[each.key].min_capacity
    resource_id = "service/${aws_ecs_cluster.dibbs_app_cluster.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_memory" {
    for_each = var.enable_autoscaling ? aws_ecs_service.this : {}
  name               = "${each.key}_memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.this[each.key].scalable_dimension
    service_namespace  = aws_appautoscaling_target.this[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "dev_to_cpu" {
for_each = var.enable_autoscaling ? aws_ecs_service.this : {}
  name               = "${each.key}_cpu"
  policy_type = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.this[each.key].scalable_dimension
    service_namespace  = aws_appautoscaling_target.this[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}

