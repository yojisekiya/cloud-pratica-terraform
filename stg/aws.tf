module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

module "aws_subnet" {
  source = "../modules/aws/subnet"
  env    = "stg"
  vpc_id = module.aws_vpc.id_cloud_pratica
}

module "aws_internet_gateway" {
  source = "../modules/aws/internet_gateway"
  env    = "stg"
}

module "aws_route_table" {
  source                   = "../modules/aws/route_table"
  env                      = local.env
  vpc_id                   = module.aws_vpc.id_cloud_pratica
  internet_gateway_id      = module.aws_internet_gateway.id_cloud_pratica
  public_subnet_ids        = local.public_subnet_ids
  private_subnet_ids       = local.private_subnet_ids
  nat_network_interface_id = "eni-02e74c31e040c6f7c"
}

## security group
module "aws_security_group" {
  source                        = "../modules/aws/security_group"
  vpc_id                        = module.aws_vpc.id_cloud_pratica
  alb_cidr_ipv4s                = local.alb_cidr_ipv4s
  db_security_group_ids         = local.db_security_group_ids
  nat_cidr_blocks               = local.nat_cidr_blocks
  referenced_security_group_ids = local.referenced_security_group_ids
  env                           = "stg"
}

# alb
import {
  to = module.aws_security_group.aws_security_group.alb
  id = "sg-06673ff41409ae988"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.alb["0.0.0.0/0"]
  id = "sgr-089d75605ac1ff234"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.alb
  id = "sgr-0de98a1004f3cf296"
}

# bastion
import {
  to = module.aws_security_group.aws_security_group.bastion
  id = "sg-060eadaffa92ddd9d"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.bastion
  id = "sgr-0f6289eb5b1d64973"
}

# db
import {
  to = module.aws_security_group.aws_security_group.db
  id = "sg-0abb9659b0f8f067a"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.db["slack_metrics_backend"]
  id = "sgr-0bc394c1488a65852"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.db["bastion"]
  id = "sgr-0b1d68cf9703064b1"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.db["db_migrator"]
  id = "sgr-0afef92e73fae7575"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.db
  id = "sgr-0aaba9d935d3bcef0"
}

# db_migrator
import {
  to = module.aws_security_group.aws_security_group.db_migrator
  id = "sg-0b1474357b7c9b6b1"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.db_migrator
  id = "sgr-0ea949fab6801005f"
}

# nat
import {
  to = module.aws_security_group.aws_security_group.nat
  id = "sg-023d560594ab002e3"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.nat["10.0.128.0/18"]
  id = "sgr-04d31a57459de1877"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.nat["10.0.192.0/18"]
  id = "sgr-0c919a7a426a2ce29"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.nat
  id = "sgr-0dbbf37b8e1c08fb9"
}

# slack_metrics_backend
import {
  to = module.aws_security_group.aws_security_group.slack_metrics_backend
  id = "sg-0999d2a144e319edf"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_ingress_rule.slack_metrics_backend["alb"]
  id = "sgr-0b844250f87b6c169"
}

import {
  to = module.aws_security_group.aws_vpc_security_group_egress_rule.slack_metrics_backend
  id = "sgr-00df73314a83595e7"
}

# default
# import {
#   to = aws_security_group.db
#   id = "sg-0abb9659b0f8f067a"
# }

# import {
#   to = aws_vpc_security_group_ingress_rule.slack_metrics_backend
#   id = "sgr-0bc394c1488a65852"
# }

# import {
#   to = aws_vpc_security_group_egress_rule.db
#   id = "sgr-0aaba9d935d3bcef0"
# }
