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
import {
  to = aws_sesv2_email_identity.cloud_pratica
  id = "stg.yojisekiya.com"
}

import {
  to = aws_sesv2_email_identity_mail_from_attributes.cloud_pratica
  id = "yojisekiya@gmail.com"
}

# ecr unit
# import {
#   to = module.aws_ecr.module.ecr_db_migrator.aws_ecr_repository.main
#   id = "db-migrator-${local.env}"
# }

# import {
#   to = module.aws_ecr.module.ecr_db_migrator.aws_ecr_lifecycle_policy.retain_latest_images
#   id = "db-migrator-${local.env}"
# }

# import {
#   to = module.aws_ecr.module.ecr_slack_metrics.aws_ecr_repository.main
#   id = "slack-metrics-${local.env}"
# }

# import {
#   to = module.aws_ecr.module.ecr_slack_metrics.aws_ecr_lifecycle_policy.retain_latest_images
#   id = "slack-metrics-${local.env}"
# }

# import {
#   to = aws_ecr_repository.db_migrator
#   id = "db-migrator-${local.env}"
# }

# import {
#   to = aws_ecr_lifecycle_policy.db_migrator
#   id = "db-migrator-${local.env}"
# }

# import {
#   to = aws_ecr_repository.slack_metrics
#   id = "slack-metrics-${local.env}"
# }

# import {
#   to = aws_ecr_lifecycle_policy.slack_metrics
#   id = "slack-metrics-${local.env}"
# }
