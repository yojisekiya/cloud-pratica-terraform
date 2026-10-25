module "aws_vpc" {
  source = "../modules/aws/vpc"
  env    = "stg"
}
