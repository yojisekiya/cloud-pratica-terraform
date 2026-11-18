# cluster
resource "aws_ecs_cluster" "cloud_pratica_backend" {
  name   = "cloud-pratica-backend-${var.env}"
  region = var.region
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# cluster capacity providers
resource "aws_ecs_cluster_capacity_providers" "cloud_pratica_backend" {
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  cluster_name       = "cloud-pratica-backend-${var.env}"
  region             = var.region
}
