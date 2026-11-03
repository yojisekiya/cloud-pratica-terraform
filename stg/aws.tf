# vpc
module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

# subnet
module "aws_subnet" {
  source = "../modules/aws/subnet"
  env    = "stg"
  vpc_id = module.aws_vpc.id_cloud_pratica
}

# internet gateway
module "aws_internet_gateway" {
  source = "../modules/aws/internet_gateway"
  env    = "stg"
}

# route table
module "aws_route_table" {
  source                   = "../modules/aws/route_table"
  env                      = local.env
  vpc_id                   = module.aws_vpc.id_cloud_pratica
  internet_gateway_id      = module.aws_internet_gateway.id_cloud_pratica
  public_subnet_ids        = local.public_subnet_ids
  private_subnet_ids       = local.private_subnet_ids
  nat_network_interface_id = "eni-02e74c31e040c6f7c"
}

# security group
module "aws_security_group" {
  source                        = "../modules/aws/security_group"
  vpc_id                        = module.aws_vpc.id_cloud_pratica
  alb_cidr_ipv4s                = local.alb_cidr_ipv4s
  db_security_group_ids         = local.db_security_group_ids
  nat_cidr_blocks               = local.nat_cidr_blocks
  referenced_security_group_ids = local.referenced_security_group_ids
  env                           = "stg"
}

# ecr
import {
  to = aws_ecr_repository.service
  id = "db-migrator-stg"
}

import {
  to = aws_ecr_lifecycle_policy.example
  id = "db-migrator-stg"
}

import {
  to = aws_ecr_repository.service
  id = "slack-metrics-stg"
}

import {
  to = aws_ecr_lifecycle_policy.example
  id = "slack-metrics-stg"
}
