resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  tags = {
    Name = "cp-rtb-public-${var.env}"
  }
}

locals {
  public_subnet_ids = ["subnet-085c5f1a60fe601b0", "subnet-06f775349a692f254"]
}

variable "public_subnet_ids" {
  type = list(string)
}

resource "aws_route_table_association" "public" {
  for_each       = toset(local.public_subnet_ids)
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}
