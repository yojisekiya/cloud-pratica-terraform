locals {
  env                    = "stg"
  account_id             = "742248953342"
  region                 = "ap-northeast-1"
  base_host              = "stg.yojisekiya.com"
  slack_metrics_api_host = "sm-api.${local.base_host}"
  public_subnet_ids = [
    module.aws_subnet.id_public_1a,
    module.aws_subnet.id_public_1c,
  ]
  private_subnet_ids = [
    module.aws_subnet.id_private_1a,
    module.aws_subnet.id_private_1c,
  ]
}
