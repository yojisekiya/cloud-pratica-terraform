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
  source                                      = "../modules/aws/iam_role"
  ssm_core_policy_attachments                 = local.ssm_core_policy_attachments
  ecs_task_execution_policy_attachments       = local.ecs_task_execution_policy_attachments
  cp_slack_metrics_backend_policy_attachments = local.cp_slack_metrics_backend_policy_attachments
  cp_slack_metrics_client_policy_attachments  = local.cp_slack_metrics_client_policy_attachments
  env                                         = local.env
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
# import {
#   to = module.aws_iam_role.aws_iam_role.cp_slack_metrics_backend
#   id = "cp-slack-metrics-backend-${local.env}"
# }

# import {
#   for_each = local.cp_slack_metrics_backend_policy_attachments

#   to = module.aws_iam_role.aws_iam_role_policy_attachment.cp_slack_metrics_backend[each.key]
#   id = "cp-slack-metrics-backend-${local.env}/${each.value}"
# }

# slack metrics client
# import {
#   to = module.aws_iam_role.aws_iam_role.cp_slack_metrics_client
#   id = "cp-slack-metrics-client-${local.env}"
# }

# import {
#   for_each = local.cp_slack_metrics_client_policy_attachments

#   to = module.aws_iam_role.aws_iam_role_policy_attachment.cp_slack_metrics_client[each.key]
#   id = "cp-slack-metrics-client-${local.env}/${each.value}"
# }

# scheduler slack metrics
import {
  to = aws_iam_role.cp_scheduler_slack_metrics
  id = "cp-scheduler-slack-metrics-${local.env}"
}

import {
  to = aws_iam_role_policy_attachment.batch_submit_job
  id = "cp-scheduler-slack-metrics-${local.env}/arn:aws:iam::${local.account_id}:policy/batch-submit-job-${local.env}"
}

import {
  to = aws_iam_role_policy_attachment.ecs_run_task
  id = "cp-scheduler-slack-metrics-${local.env}/arn:aws:iam::${local.account_id}:policy/ecs-run-task-${local.env}"
}

import {
  to = aws_iam_role_policy_attachment.lambda_invoke
  id = "cp-scheduler-slack-metrics-${local.env}/arn:aws:iam::${local.account_id}:policy/lambda-invoke-${local.env}"
}

import {
  to = aws_iam_role_policy_attachment.pass_role_to_ecs_task
  id = "cp-scheduler-slack-metrics-${local.env}/arn:aws:iam::${local.account_id}:policy/pass-role-to-ecs-task-${local.env}"
}

# # policies
# import {
#   to = module.aws_iam_role.aws_iam_policy.secrets_manager_read
#   id = "arn:aws:iam::${local.account_id}:policy/secrets-manager-read-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_policy.s3_read
#   id = "arn:aws:iam::${local.account_id}:policy/s3-read-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_policy.sqs_read_write
#   id = "arn:aws:iam::${local.account_id}:policy/sqs-read-write-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_policy.ses_send_email
#   id = "arn:aws:iam::${local.account_id}:policy/ses-send-email-${local.env}"
# }

# import {
#   to = module.aws_iam_role.aws_iam_policy.cloud_watch_logs_write
#   id = "arn:aws:iam::${local.account_id}:policy/cloud-watch-logs-write-${local.env}"
# }

import {
  to = aws_iam_policy.ecs_run_task
  id = "arn:aws:iam::${local.account_id}:policy/ecs-run-task-${local.env}"
}

import {
  to = aws_iam_policy.pass_role_to_ecs_task
  id = "arn:aws:iam::${local.account_id}:policy/pass-role-to-ecs-task-${local.env}"
}

import {
  to = aws_iam_policy.batch_submit_job
  id = "arn:aws:iam::${local.account_id}:policy/batch-submit-job-${local.env}"
}

import {
  to = aws_iam_policy.lambda_invoke
  id = "arn:aws:iam::${local.account_id}:policy/lambda-invoke-${local.env}"
}
