module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

import {
  to = aws_subnet.temp
  id = "subnet-06f775349a692f254"
}

resource "aws_subnet" "temp" {
  assign_ipv6_address_on_creation = false
  cidr_block                      = "10.0.64.0/18"
  tags = {
    Name = "public-subnet-1c-stg"
  }
  vpc_id = "vpc-08aea5c1ca995e705"
}
