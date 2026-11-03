resource "aws_sqs_queue" "slack_metrics" {
  delay_seconds                     = 0
  kms_data_key_reuse_period_seconds = 300
  max_message_size                  = 262144
  message_retention_seconds         = 86400
  name                              = "slack-metrics-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = "arn:aws:sqs:ap-northeast-1:${var.account_id}:slack-metrics-${var.env}"
    }]
    Version = "2012-10-17"
  })
  receive_wait_time_seconds = 20
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:ap-northeast-1:${var.account_id}:slack-metrics-dlq-${var.env}"
    maxReceiveCount     = 3
  })
  region                     = "ap-northeast-1"
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 1800
}

resource "aws_sqs_queue_policy" "slack_metrics" {
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = "arn:aws:sqs:ap-northeast-1:${var.account_id}:slack-metrics-${var.env}"
    }]
    Version = "2012-10-17"
  })
  queue_url = "https://sqs.ap-northeast-1.amazonaws.com/${var.account_id}/slack-metrics-${var.env}"
  region    = "ap-northeast-1"
}

resource "aws_sqs_queue" "slack_metrics_dlq" {
  delay_seconds                     = 0
  kms_data_key_reuse_period_seconds = 300
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  name                              = "slack-metrics-dlq-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = "arn:aws:sqs:ap-northeast-1:${var.account_id}:slack-metrics-dlq-${var.env}"
    }]
    Version = "2012-10-17"
  })
  region                     = "ap-northeast-1"
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 30
}

resource "aws_sqs_queue_policy" "slack_metrics_dlq" {
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = "arn:aws:sqs:ap-northeast-1:${var.account_id}:slack-metrics-dlq-${var.env}"
    }]
    Version = "2012-10-17"
  })
  queue_url = "https://sqs.ap-northeast-1.amazonaws.com/${var.account_id}/slack-metrics-dlq-${var.env}"
  region    = "ap-northeast-1"
}
