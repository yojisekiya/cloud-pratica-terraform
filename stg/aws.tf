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

## iam role
module "aws_iam_role" {
  source                                = "../modules/aws/iam_role"
  ssm_core_policy_attachments           = local.ssm_core_policy_attachments
  ecs_task_execution_policy_attachments = local.ecs_task_execution_policy_attachments
  env                                   = local.env
}

# # db migrator
# import {
#   to = module.aws_iam_role.aws_iam_role.cp_db_migrator
#   id = "cp-db-migrator-${local.env}"
# }

# # bastion
# import {
#   to = module.aws_iam_role.aws_iam_role.cp_bastion
#   id = "cp-bastion-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_role_policy_attachment.cp_bastion["ssm_core"]
#   id = "cp-bastion-${local.env}/${local.ssm_core_policy_attachments["ssm_core"]}"
# }

# # nat
# import {
#   to = module.aws_iam_role.aws_iam_role.cp_nat
#   id = "cp-nat-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_role_policy_attachment.cp_nat["ssm_core"]
#   id = "cp-nat-${local.env}/${local.ssm_core_policy_attachments["ssm_core"]}"
# }

# # ecs task execution
# import {
#   to = module.aws_iam_role.aws_iam_role.ecs_task_execution
#   id = "ecs-task-execution-${local.env}"
# }

# import {
#   for_each = local.ecs_task_execution_policy_attachments

#   to = module.aws_iam_role.aws_iam_role_policy_attachment.ecs_task_execution[each.key]
#   id = "ecs-task-execution-${local.env}/${each.value}"
# }

# slack metrics backend
import {
  to = aws_iam_role.cp_slack_metrics_backend
  id = "cp-slack-metrics-backend-${local.env}"
}

import {
  to = aws_iam_role_policy_attachment.ssm_core
  id = "cp-slack-metrics-backend-${local.env}/${local.cp_slack_metrics_backend_policy_attachments.ssm_core}"
}

import {
  to = aws_iam_role_policy_attachment.cloudwatch
  id = "cp-slack-metrics-backend-${local.env}/${local.cp_slack_metrics_backend_policy_attachments.cloudwatch}"
}

import {
  to = aws_iam_role_policy_attachment.s3
  id = "cp-slack-metrics-backend-${local.env}/${local.cp_slack_metrics_backend_policy_attachments.s3}"
}

import {
  to = aws_iam_role_policy_attachment.ses
  id = "cp-slack-metrics-backend-${local.env}/${local.cp_slack_metrics_backend_policy_attachments.ses}"
}

import {
  to = aws_iam_role_policy_attachment.sqs
  id = "cp-slack-metrics-backend-${local.env}/${local.cp_slack_metrics_backend_policy_attachments.sqs}"
}

# examples
# import {
#   to = aws_ecr_repository.main
#   id = "db-migrator-${local.env}"
# }

# import {
#   to = module.aws_ses.aws_sesv2_email_identity.cloud_pratica
#   id = "stg.yojisekiya.com"
# }
