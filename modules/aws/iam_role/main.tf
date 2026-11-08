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
