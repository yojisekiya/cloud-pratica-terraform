# db migrator
resource "aws_iam_role" "cp_db_migrator" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      }, {
      Action = ["sts:AssumeRole", "sts:TagSession"]
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-db-migrator-${var.env}"
}

# bastion
resource "aws_iam_role" "cp_bastion" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-bastion-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_bastion" {
  for_each = var.ssm_core_policy_attachments

  role       = aws_iam_role.cp_bastion.name
  policy_arn = each.value
}

# nat
resource "aws_iam_role" "cp_nat" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-nat-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_nat" {
  for_each = var.ssm_core_policy_attachments

  role       = aws_iam_role.cp_nat.name
  policy_arn = each.value
}

# ecs task execution
resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description          = "Allows ECS tasks to call AWS services on your behalf."
  max_session_duration = 3600
  name                 = "ecs-task-execution-stg"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  for_each = var.ecs_task_execution_policy_attachments

  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = each.value
}

# slack metrics backend
resource "aws_iam_role" "cp_slack_metrics_backend" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      }, {
      Action = ["sts:AssumeRole", "sts:TagSession"]
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description          = "Allows SSM to call AWS services on your behalf"
  max_session_duration = 3600
  name                 = "cp-slack-metrics-backend-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_slack_metrics_backend" {
  for_each = var.cp_slack_metrics_backend_policy_attachments

  policy_arn = each.value
  role       = "cp-slack-metrics-backend-${var.env}"
}
