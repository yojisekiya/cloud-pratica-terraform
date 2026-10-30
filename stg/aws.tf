module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

module "aws_subnet" {
  source = "../modules/aws/subnet"
  env    = "stg"
  vpc_id = module.aws_vpc.id_cloud_pratica
}

# import {
#   to = module.aws_subnet.aws_subnet.private_subnet_1a
#   id = "subnet-07ab49d75f74606d3"
# }

# import {
#   to = module.aws_subnet.aws_subnet.private_subnet_1c
#   id = "subnet-064bf7a0032eba3f9"
# }

# import {
#   to = module.aws_subnet.aws_subnet.public_subnet_1a
#   id = "subnet-085c5f1a60fe601b0"
# }

# import {
#   to = module.aws_subnet.aws_subnet.public_subnet_1c
#   id = "subnet-06f775349a692f254"
# }

import {
  to = aws_internet_gateway.gw
  id = "igw-0e1e01dcc30de1b8f"
}

resource "aws_internet_gateway" "gw" {
  region = "ap-northeast-1"
  tags = {
    Name = "cp-igw-stg"
  }
  vpc_id = "vpc-08aea5c1ca995e705"
}
