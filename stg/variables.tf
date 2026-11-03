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
  alb_cidr_ipv4s = [
    "0.0.0.0/0",
  ]
  db_security_group_ids = {
    slack_metrics_backend = "sg-0999d2a144e319edf"
    bastion               = "sg-060eadaffa92ddd9d"
    db_migrator           = "sg-0b1474357b7c9b6b1"
  }
  nat_cidr_blocks = [
    "10.0.128.0/18",
    "10.0.192.0/18"
  ]
  referenced_security_group_ids = {
    alb = "sg-06673ff41409ae988"
  }
  secrets_manager_arn = "arn:aws:secretsmanager:ap-northeast-1:742248953342:secret:db-main-instance-stg-kYBcCp"
}
