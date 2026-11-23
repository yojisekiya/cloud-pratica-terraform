# load balancer
resource "aws_lb" "cloud_pratica" {
  client_keep_alive                = 3600
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 60
  ip_address_type                  = "ipv4"
  load_balancer_type               = "application"
  name                             = "cp-alb-${var.env}"
  region                           = var.region
  security_groups                  = var.cloud_pratica.security_group_ids
  subnets                          = var.cloud_pratica.subnet_ids
  xff_header_processing_mode       = "append"
}

# listener
resource "aws_lb_listener" "cp_https" {
  certificate_arn                      = var.cloud_pratica.certificate_arn
  load_balancer_arn                    = aws_lb.cloud_pratica.arn
  port                                 = 443
  protocol                             = "HTTPS"
  region                               = var.region
  routing_http_response_server_enabled = true
  ssl_policy                           = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  default_action {
    order = 1
    type  = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 forbidden"
      status_code  = "403"
    }
  }
  mutual_authentication {
    mode = "off"
  }
}

# listener rule
resource "aws_lb_listener_rule" "slack_metrics_api" {
  listener_arn = aws_lb_listener.cp_https.arn
  region       = var.region
  tags = {
    Name = "slack-metrics-api"
  }
  tags_all = {
    Env  = "stg"
    Name = "slack-metrics-api"
  }
  action {
    order = 1
    type  = "forward"
    forward {
      stickiness {
        enabled  = false
        duration = 3600
      }
      target_group {
        arn    = var.cloud_pratica.target_group_arn_slack_metrics_api
        weight = 1
      }
    }
  }
  condition {
    host_header {
      values = [var.cloud_pratica.slack_metrics_api_host]
    }
  }
}
