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
  source            = "../modules/aws/ecs"
  region            = local.region
  slack_metrics_api = local.slack_metrics_api
  env               = local.env
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

# event bridge scheduler
module "aws_event_bridge_scheduler" {
  source             = "../modules/aws/event_bridge_scheduler"
  region             = local.region
  private_subnet_ids = local.private_subnet_ids
  slack_metrics = {
    iam_role_arn                             = module.aws_iam_role.role_arn_cp_scheduler_slack_metrics
    ecs_cluster_arn                          = module.aws_ecs.ecs_cluster_arn_cloud_pratica_backend
    ecs_task_definition_arn_without_revision = module.aws_ecs_task_definition.arn_without_revision_slack_metrics_batch
    security_group_id                        = module.aws_security_group.id_slack_metrics_backend
  }
  cost_cutter = {
    enable       = true
    iam_role_arn = module.aws_iam_role.role_arn_cp_scheduler_cost_cutter
    ec2_instance_ids = [
      module.aws_ec2.id_nat_1a,
      module.aws_ec2.id_bastion,
    ]
    ecs_cluster_arn_cloud_pratica_backend = module.aws_ecs.ecs_cluster_arn_cloud_pratica_backend
  }
  env = local.env
}

# target group
module "aws_target_group" {
  source = "../modules/aws/target_group"
  region = local.region
  vpc_id = module.aws_vpc.id_cloud_pratica
  env    = local.env
}

# load balancer
module "aws_alb" {
  source = "../modules/aws/alb"
  region = local.region
  cloud_pratica = {
    security_group_ids                 = [module.aws_security_group.id_alb_cp]
    subnet_ids                         = local.public_subnet_ids
    certificate_arn                    = "arn:aws:acm:${local.region}:${local.account_id}:certificate/b972a7c0-9d54-4975-9e73-d0937b70467c"
    target_group_arn_slack_metrics_api = module.aws_target_group.arn_slack_metrics_api
    slack_metrics_api_host             = local.slack_metrics_api_host
  }
  env = local.env
}

# s3
module "aws_s3" {
  source                      = "../modules/aws/s3"
  cloudfront_distribution_arn = "arn:aws:cloudfront::${local.account_id}:distribution/E1EMXRQLV0TYZ0"
  env                         = local.env
}

## imports
import {
  to = aws_cloudfront_distribution.slack_metrics
  id = "E1EMXRQLV0TYZ0"
}

import {
  to = aws_cloudfront_origin_access_control.s3_slack_metrics
  id = "EGQB2P7IXCF2G"
}
