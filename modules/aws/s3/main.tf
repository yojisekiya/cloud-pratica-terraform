module "cp_config" {
  source                           = "terraform-aws-modules/s3-bucket/aws"
  version                          = "5.10.0"
  bucket                           = "cp-yoji-config-${var.env}"
  skip_destroy_public_access_block = false
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled       = true
      blocked_encryption_types = ["SSE-C"]
    }
  }
}

module "slack_metrics" {
  source                           = "terraform-aws-modules/s3-bucket/aws"
  version                          = "5.10.0"
  bucket                           = "cp-slack-metrics-yoji-${var.env}"
  skip_destroy_public_access_block = false
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled       = true
      blocked_encryption_types = ["SSE-C"]
    }
  }
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::cp-slack-metrics-yoji-${var.env}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}
