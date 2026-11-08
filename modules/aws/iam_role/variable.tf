variable "env" {
  type = string
}

variable "ssm_core_policy_attachments" {
  type = map(string)
}

variable "ecs_task_execution_policy_attachments" {
  type = map(string)
}

variable "cp_slack_metrics_backend_policy_attachments" {
  type = map(string)
}

variable "cp_slack_metrics_client_policy_attachments" {
  type = map(string)
}
