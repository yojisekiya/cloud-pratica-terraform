resource "aws_subnet" "public_subnet_1c" {
  assign_ipv6_address_on_creation = false
  cidr_block                      = "10.0.64.0/18"
  tags = {
    Name = "public-subnet-1c-${var.env}"
  }
  vpc_id = var.vpc_id
}
