#alb
resource "aws_security_group" "alb" {
  description = "Managed by Terraform"
  name        = "cp-alb-${var.env}"
  region      = "ap-northeast-1"
  tags = {
    Name = "cp-alb-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-06673ff41409ae988"
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  for_each          = toset(var.alb_cidr_ipv4s)
  cidr_ipv4         = each.value
  from_port         = 443
  ip_protocol       = "tcp"
  region            = "ap-northeast-1"
  security_group_id = "sg-06673ff41409ae988"
  to_port           = 443
}

# bastion
resource "aws_security_group" "bastion" {
  description = "Managed by Terraform"
  name        = "cp-bastion-${var.env}"
  region      = "ap-northeast-1"
  tags = {
    Name = "cp-bastion-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-060eadaffa92ddd9d"
}

# db
resource "aws_security_group" "db" {
  description            = "Managed by Terraform"
  name                   = "cp-db-${var.env}"
  region                 = "ap-northeast-1"
  revoke_rules_on_delete = null
  tags = {
    Env  = var.env
    Name = "cp-db-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  for_each                     = var.db_security_group_ids
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
  security_group_id            = "sg-0abb9659b0f8f067a"
  region                       = "ap-northeast-1"
}

resource "aws_vpc_security_group_egress_rule" "db" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-0abb9659b0f8f067a"
}

# db_migrator
resource "aws_security_group" "db_migrator" {
  description = "Managed by Terraform"
  name        = "cp-db-migrator-${var.env}"
  region      = "ap-northeast-1"
  tags = {
    Name = "cp-db-migrator-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "db_migrator" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-0b1474357b7c9b6b1"
}

# nat
resource "aws_security_group" "nat" {
  description = "Managed by Terraform"
  name        = "cp-nat-${var.env}"
  region      = "ap-northeast-1"
  tags = {
    Name = "cp-nat-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "nat" {
  for_each          = toset(var.nat_cidr_blocks)
  cidr_ipv4         = each.value
  description       = "Allow traffic from private subnets"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-023d560594ab002e3"
}

resource "aws_vpc_security_group_egress_rule" "nat" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-023d560594ab002e3"
}

# slack_metrics_backend
resource "aws_security_group" "slack_metrics_backend" {
  description = "Managed by Terraform"
  name        = "cp-slack-metrics-backend-${var.env}"
  region      = "ap-northeast-1"
  tags = {
    Name = "cp-slack-metrics-backend-${var.env}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "slack_metrics_backend" {
  for_each                     = var.referenced_security_group_ids
  from_port                    = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
  region                       = "ap-northeast-1"
  security_group_id            = "sg-0999d2a144e319edf"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "slack_metrics_backend" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  region            = "ap-northeast-1"
  security_group_id = "sg-0999d2a144e319edf"
}
