output "alb_cidr_ipv4" {
  value = [
    for rule in aws_vpc_security_group_ingress_rule.alb :
    rule.cidr_ipv4
  ]
}

output "id_slack_metrics_backend" {
  value = aws_security_group.slack_metrics_backend.id
}
