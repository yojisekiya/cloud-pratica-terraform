variable "env" {}
variable "region" {}
variable "cloud_pratica" {
  type = object({
    security_group_ids                 = list(string)
    subnet_ids                         = list(string)
    certificate_arn                    = string
    target_group_arn_slack_metrics_api = string
    slack_metrics_api_host             = string
  })
}
