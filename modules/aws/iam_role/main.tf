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

# slack metrics client
resource "aws_iam_role" "cp_slack_metrics_client" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "amplify.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-slack-metrics-client-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_slack_metrics_client" {
  for_each = var.cp_slack_metrics_client_policy_attachments

  policy_arn = each.value
  role       = "cp-slack-metrics-client-${var.env}"
}

# cp scheduler slack metrics
resource "aws_iam_role" "cp_scheduler_slack_metrics" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-scheduler-slack-metrics-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_scheduler_slack_metrics" {
  for_each = var.cp_scheduler_slack_metrics_policy_attachments

  policy_arn = each.value
  role       = "cp-scheduler-slack-metrics-${var.env}"
}

# cp scheduler cost cutter
resource "aws_iam_role" "cp_scheduler_cost_cutter" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  max_session_duration = 3600
  name                 = "cp-scheduler-cost-cutter-${var.env}"
}

resource "aws_iam_role_policy_attachment" "cp_scheduler_cost_cutter" {
  for_each = var.cp_scheduler_cost_cutter_policy_attachments

  policy_arn = each.value
  role       = "cp-scheduler-cost-cutter-${var.env}"
}

# policies
resource "aws_iam_policy" "sqs_read_write" {
  name = "sqs-read-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ses_send_email" {
  name = "ses-send-email-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["ses:SendEmail", "ses:SendRawEmail"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "s3_read" {
  name = "s3-read-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["s3:ListBucket", "s3:GetObject", "s3:GetObjectVersion"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "secrets_manager_read" {
  name = "secrets-manager-read-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "cloud_watch_logs_write" {
  name = "cloud-watch-logs-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_run_task" {
  name = "ecs-run-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = "ecs:RunTask"
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "lambda_invoke" {
  name = "lambda-invoke-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["lambda:InvokeFunction", "lambda:GetFunctionConfiguration"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "batch_submit_job" {
  name = "batch-submit-job-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["batch:SubmitJob"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "pass_role_to_ecs_task" {
  name = "pass-role-to-ecs-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action = "iam:PassRole"
      Condition = {
        StringEquals = {
          "iam:PassedToService" = "ecs-tasks.amazonaws.com"
        }
      }
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "rds_start_stop" {
  name = "rds-start-stop-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["rds:StartDBInstance", "rds:StopDBInstance"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_write" {
  name = "ecs-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["ecs:UpdateService", "ecs:RunTask"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ec2_start_stop" {
  name = "ec2-start-stop-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = ["ec2:StartInstances", "ec2:StopInstances"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}
