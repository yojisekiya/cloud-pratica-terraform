variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "slack_metrics_api" {
  type = object({
    name               = string
    target_group_arn   = optional(string)
    subnet_ids         = list(string)
    task_definition    = string
    capacity_provider  = string
    security_group_ids = list(string)
    service_namespace  = string
  })
}
