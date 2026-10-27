module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}

import {
  to = aws_subnet.temp
  id = "subnet-06f775349a692f254"
}
