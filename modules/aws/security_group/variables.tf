variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_cidr_ipv4s" {
  type = list(string)
}

variable "db_security_group_ids" {
  type = map(string)
}

variable "nat_cidr_blocks" {
  type = list(string)
}

variable "referenced_security_group_ids" {
  type = map(string)
}
