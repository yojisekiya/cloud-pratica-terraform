# ecs cluster
resource "aws_ecs_cluster" "cloud_pratica_backend" {
  name   = "cloud-pratica-backend-${var.env}"
  region = var.region
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# ecs cluster capacity providers
resource "aws_ecs_cluster_capacity_providers" "cloud_pratica_backend" {
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  cluster_name       = "cloud-pratica-backend-${var.env}"
  region             = var.region
}

# ecs service
resource "aws_ecs_service" "slack_metrics_api" {
  availability_zone_rebalancing      = "ENABLED"
  cluster                            = aws_ecs_cluster.cloud_pratica_backend.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  enable_ecs_managed_tags            = true
  enable_execute_command             = true
  name                               = var.slack_metrics_api.name
  region                             = var.region
  scheduling_strategy                = "REPLICA"
  task_definition                    = var.slack_metrics_api.task_definition
  capacity_provider_strategy {
    base              = 0
    capacity_provider = var.slack_metrics_api.capacity_provider
    weight            = 1
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  deployment_controller {
    type = "ECS"
  }
  dynamic "load_balancer" {
    for_each = var.slack_metrics_api.target_group_arn != null ? [1] : []
    content {
      container_name   = "api"
      container_port   = 8080
      target_group_arn = var.slack_metrics_api.target_group_arn
    }
  }
  network_configuration {
    assign_public_ip = false
    security_groups  = var.slack_metrics_api.security_group_ids
    subnets          = var.slack_metrics_api.subnet_ids
  }
  lifecycle {
    ignore_changes = [
      # MEMO: コスト削減で落とすタイミングがあるため
      desired_count,
      # MEMO: ecspressoからタスク定義のリビジョンを更新するため
      task_definition,
    ]
  }
}

# ecs autoscaling target
resource "aws_appautoscaling_target" "slack_metrics_api" {
  service_namespace  = var.slack_metrics_api.service_namespace
  resource_id        = "service/${aws_ecs_cluster.cloud_pratica_backend.name}/${var.slack_metrics_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 2
  depends_on         = [aws_ecs_service.slack_metrics_api]
}

# ecs autoscaling policy
resource "aws_appautoscaling_policy" "slack_metrics_api_cpu" {
  name               = "target-tracking-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.slack_metrics_api.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = var.slack_metrics_api.service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in   = false
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
    target_value       = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "slack_metrics_api_memory" {
  name               = "target-tracking-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.slack_metrics_api.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = var.slack_metrics_api.service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in   = false
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
    target_value       = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}
