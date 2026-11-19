/************************************************************
Common
************************************************************/
variable "env" {}
variable "ecs_task_execution_role_arn" {}
variable "secrets_manager_arn_db_main_instance" {}
variable "ecs_task_role_arn_slack_metrics" {}
variable "ecs_task_role_arn_db_migrator" {}
variable "ecr_url_db_migrator" {}
variable "ecr_url_slack_metrics" {}
variable "arn_cp_config_bucket" {}
variable "ecs_task_specs" {
  type = object({
    slack_metrics_api = object({
      cpu    = number
      memory = number
    })
    slack_metrics_batch = object({
      cpu    = number
      memory = number
    })
    db_migrator = object({
      cpu    = number
      memory = number
    })
    practice_ecs_calculate = object({
      cpu    = number
      memory = number
    })
    media_compressor_compress_video = object({
      cpu    = number
      memory = number
    })
    cost_api = object({
      cpu    = number
      memory = number
    })
  })
}
