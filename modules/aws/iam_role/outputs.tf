output "iam_policy_arns" {
  value = {
    secrets_manager = aws_iam_policy.secrets_manager_read.arn
    s3_read         = aws_iam_policy.s3_read.arn
    ses             = aws_iam_policy.ses_send_email.arn
    sqs             = aws_iam_policy.sqs_read_write.arn
    cloudwatch      = aws_iam_policy.cloud_watch_logs_write.arn
  }
}
