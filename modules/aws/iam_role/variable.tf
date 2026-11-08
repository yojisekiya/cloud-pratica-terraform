variable "env" {
  type = string
}

variable "ssm_core_policy_attachments" {
  type = map(string)
}

variable "ecs_task_execution_policy_attachments" {
  type = map(string)
}
