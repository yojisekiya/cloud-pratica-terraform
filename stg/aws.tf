## modules

# vpc
module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = local.env
}

# subnet
module "aws_subnet" {
  source = "../modules/aws/subnet"
  env    = local.env
  vpc_id = module.aws_vpc.id_cloud_pratica
}

# internet gateway
module "aws_internet_gateway" {
  source = "../modules/aws/internet_gateway"
  env    = local.env
}

# route table
module "aws_route_table" {
  source                   = "../modules/aws/route_table"
  env                      = local.env
  vpc_id                   = module.aws_vpc.id_cloud_pratica
  internet_gateway_id      = module.aws_internet_gateway.id_cloud_pratica
  public_subnet_ids        = local.public_subnet_ids
  private_subnet_ids       = local.private_subnet_ids
  nat_network_interface_id = local.nat_network_interface_id
}

# security group
module "aws_security_group" {
  source                        = "../modules/aws/security_group"
  vpc_id                        = module.aws_vpc.id_cloud_pratica
  alb_cidr_ipv4s                = local.alb_cidr_ipv4s
  db_security_group_ids         = local.db_security_group_ids
  nat_cidr_blocks               = local.nat_cidr_blocks
  referenced_security_group_ids = local.referenced_security_group_ids
  env                           = local.env
}

# ecr
module "aws_ecr" {
  source = "../modules/aws/ecr"
  env    = local.env
}

# secrets manager
module "aws_secrets_manager" {
  source = "../modules/aws/secrets_manager"
  env    = local.env
}

# sqs
module "aws_sqs" {
  source     = "../modules/aws/sqs"
  account_id = local.account_id
  env        = local.env
}

# ses
module "aws_ses" {
  source         = "../modules/aws/ses"
  base_host      = local.base_host
  email_identity = local.email_identity
  env            = local.env
}

# iam role
module "aws_iam_role" {
  source                                        = "../modules/aws/iam_role"
  ssm_core_policy_attachments                   = local.ssm_core_policy_attachments
  ecs_task_execution_policy_attachments         = local.ecs_task_execution_policy_attachments
  cp_slack_metrics_backend_policy_attachments   = local.cp_slack_metrics_backend_policy_attachments
  cp_slack_metrics_client_policy_attachments    = local.cp_slack_metrics_client_policy_attachments
  cp_scheduler_slack_metrics_policy_attachments = local.cp_scheduler_slack_metrics_policy_attachments
  cp_scheduler_cost_cutter_policy_attachments   = local.cp_scheduler_cost_cutter_policy_attachments
  administrator_policy_attachments              = local.administrator_policy_attachments
  env                                           = local.env
}

# ec2
module "aws_ec2" {
  source = "../modules/aws/ec2"
  env    = local.env
}

# rds
module "aws_rds" {
  source             = "../modules/aws/rds"
  account_id         = local.account_id
  private_subnet_ids = local.private_subnet_ids
  env                = local.env
}

# acm_cloud_pratica_com_ap_northeast_1
module "acm_cloud_pratica_com_ap_northeast_1" {
  source    = "../modules/aws/acm_cloud_pratica_com_ap_northeast_1"
  base_host = local.base_host
  env       = local.env
}

# acm_cloud_pratica_com_us_east_1
module "acm_cloud_pratica_com_us_east_1" {
  source    = "../modules/aws/acm_cloud_pratica_com_us_east_1"
  base_host = local.base_host
  env       = local.env
}

# ecs
module "aws_ecs" {
  source = "../modules/aws/ecs"
  region = local.region
  slack_metrics_api = {
    name               = "slack-metrics-api-${local.env}"
    target_group_arn   = "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:targetgroup/slack-metrics-api-${local.env}/f6c44e40b672957d"
    subnet_ids         = local.private_subnet_ids
    task_definition    = module.aws_ecs_task_definition.arn_slack_metrics_api
    capacity_provider  = "FARGATE_SPOT"
    security_group_ids = [module.aws_security_group.id_slack_metrics_backend]
  }
  env = local.env
}

# ecs task definitions
module "aws_ecs_task_definition" {
  source                               = "../modules/aws/ecs_task_definition"
  env                                  = local.env
  ecs_task_execution_role_arn          = module.aws_iam_role.role_arn_ecs_task_execution
  ecs_task_role_arn_slack_metrics      = module.aws_iam_role.role_arn_cp_slack_metrics_backend
  ecs_task_role_arn_db_migrator        = module.aws_iam_role.role_arn_cp_db_migrator
  secrets_manager_arn_db_main_instance = module.aws_secrets_manager.arn_db_main_instance
  ecr_url_db_migrator                  = "${module.aws_ecr.url_db_migrator}:a8244ba"
  ecr_url_slack_metrics                = "${module.aws_ecr.url_slack_metrics}:a8244ba"
  arn_cp_config_bucket                 = local.arn_cp_config_bucket
  ecs_task_specs = {
    slack_metrics_api = {
      cpu    = 256
      memory = 512
    }
    slack_metrics_batch = {
      cpu    = 256
      memory = 512
    }
    db_migrator = {
      cpu    = 256
      memory = 512
    }
    practice_ecs_calculate = {
      cpu    = 256
      memory = 512
    }
    media_compressor_compress_video = {
      cpu    = 2048
      memory = 4096
    }
    cost_api = {
      cpu    = 512
      memory = 1024
    }
  }
}

## imports
import {
  to = module.aws_ecs.aws_ecs_service.slack_metrics_api
  id = "cloud-pratica-backend-${local.env}/slack-metrics-api-${local.env}"
}
