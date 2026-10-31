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
  source              = "../modules/aws/route_table"
  env                 = local.env
  vpc_id              = module.aws_vpc.id_cloud_pratica
  internet_gateway_id = module.aws_internet_gateway.id_cloud_pratica
  public_subnet_ids   = local.public_subnet_ids
}

import {
  to = module.aws_route_table.aws_route_table_association.public["subnet-085c5f1a60fe601b0"]
  id = "subnet-085c5f1a60fe601b0/rtb-02c3903a835c40d33"
}

import {
  to = module.aws_route_table.aws_route_table_association.public["subnet-06f775349a692f254"]
  id = "subnet-06f775349a692f254/rtb-02c3903a835c40d33"
}

