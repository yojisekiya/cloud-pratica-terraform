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

## imports
import {
  to = module.aws_ec2.aws_instance.nat_1a
  id = "i-0775417918d163357"
}

import {
  to = module.aws_ec2.aws_instance.bastion
  id = "i-0cc527f04c2a6486b"
}
