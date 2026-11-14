resource "aws_instance" "bastion" {
  ami                                  = "ami-0b4d2909a55ed2c78"
  availability_zone                    = "ap-northeast-1a"
  iam_instance_profile                 = "cp-bastion-${var.env}"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  placement_partition_number           = 0
  region                               = "ap-northeast-1"
  tags = {
    Name = "cp-bastion-${var.env}"
  }
  tenancy = "default"
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  primary_network_interface {
    network_interface_id = "eni-0889f2f62fbb11f1a"
  }
  private_dns_name_options {
    hostname_type = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}

resource "aws_instance" "nat_1a" {
  ami                                  = "ami-0b4d2909a55ed2c78"
  availability_zone                    = "ap-northeast-1a"
  iam_instance_profile                 = "cp-nat-${var.env}"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  placement_partition_number           = 0
  region                               = "ap-northeast-1"
  subnet_id                            = "subnet-085c5f1a60fe601b0"
  vpc_security_group_ids               = ["sg-023d560594ab002e3"]
  source_dest_check                    = false
  tags = {
    Name = "cp-nat-1a-${var.env}"
  }
  tenancy = "default"
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    hostname_type = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}
