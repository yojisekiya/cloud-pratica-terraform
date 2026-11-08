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
  nat_network_interface_id = "eni-02e74c31e040c6f7c"
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
  secrets_manager_arn = "arn:aws:secretsmanager:ap-northeast-1:${local.account_id}:secret:db-main-instance-${local.env}-kYBcCp"
  email_identity      = "yojisekiya@gmail.com"
  iam_policy_arns = {
    task_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ssm_core       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    s3             = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    cloudwatch     = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }
  ssm_core_policy_attachments = {
    ssm_core = local.iam_policy_arns.ssm_core
  }
  ecs_task_execution_policy_attachments = {
    task_execution = local.iam_policy_arns.task_execution
    s3             = local.iam_policy_arns.s3
    cloudwatch     = local.iam_policy_arns.cloudwatch
    secret_manager = module.aws_iam_role.iam_policy_arns.secrets_manager
  }
  cp_slack_metrics_backend_policy_attachments = {
    ssm_core   = local.iam_policy_arns.ssm_core
    cloudwatch = local.iam_policy_arns.cloudwatch
    s3         = module.aws_iam_role.iam_policy_arns.s3_read
    ses        = module.aws_iam_role.iam_policy_arns.ses
    sqs        = module.aws_iam_role.iam_policy_arns.sqs
  }
  cp_slack_metrics_client_policy_attachments = {
    cloud_watch_logs_write = module.aws_iam_role.iam_policy_arns.cloudwatch
  }
}
