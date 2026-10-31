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

import {
  to = aws_route_table.public_rt
  id = "rtb-02c3903a835c40d33"
}
