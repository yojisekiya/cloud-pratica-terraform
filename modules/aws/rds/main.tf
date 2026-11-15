resource "aws_db_instance" "main" {
  allocated_storage                     = 20
  availability_zone                     = "ap-northeast-1a"
  backup_target                         = "region"
  backup_window                         = "19:20-19:50"
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  copy_tags_to_snapshot                 = true
  database_insights_mode                = "standard"
  db_subnet_group_name                  = "cp-db-subnet-group-${var.env}"
  engine                                = "postgres"
  engine_lifecycle_support              = "open-source-rds-extended-support-disabled"
  engine_version                        = "18.3"
  identifier                            = "cloud-pratica-${var.env}"
  instance_class                        = "db.t3.micro"
  kms_key_id                            = "arn:aws:kms:ap-northeast-1:${var.account_id}:key/62be65f3-2e26-4365-8de0-d6bde533f772"
  license_model                         = "postgresql-license"
  maintenance_window                    = "wed:14:44-wed:15:14"
  max_allocated_storage                 = 1000
  network_type                          = "IPV4"
  option_group_name                     = "default:postgres-18"
  parameter_group_name                  = "default.postgres18"
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:ap-northeast-1:${var.account_id}:key/62be65f3-2e26-4365-8de0-d6bde533f772"
  performance_insights_retention_period = 7
  port                                  = 5432
  region                                = "ap-northeast-1"
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "gp2"
  username                              = "postgres"
  vpc_security_group_ids                = ["sg-0abb9659b0f8f067a"]
}

resource "aws_db_parameter_group" "parameter_group" {
  description = "Managed by Terraform"
  family      = "postgres18"
  name        = "cp-db-parameter-group-postgres18-${var.env}"
  region      = "ap-northeast-1"
  tags_all = {
    Env = "stg"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  description = "Managed by Terraform"
  name        = "cp-db-subnet-group-${var.env}"
  region      = "ap-northeast-1"
  subnet_ids  = var.private_subnet_ids
  tags = {
    Name = "cp-db-subnet-group-${var.env}"
  }
  tags_all = {
    Env  = var.env
    Name = "cp-db-subnet-group-${var.env}"
  }
}
