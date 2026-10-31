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

import {
  to = module.aws_route_table.aws_route_table.private
  id = "rtb-04c18788eaaccb0d9"
}

import {
  to = module.aws_route_table.aws_route_table_association.private["cp-rtb-private/subnet-07ab49d75f74606d3"]
  id = "subnet-07ab49d75f74606d3/rtb-04c18788eaaccb0d9"
}

import {
  to = module.aws_route_table.aws_route_table_association.private["cp-rtb-private/subnet-064bf7a0032eba3f9"]
  id = "subnet-064bf7a0032eba3f9/rtb-04c18788eaaccb0d9"
}
