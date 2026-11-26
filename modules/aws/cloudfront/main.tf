resource "aws_cloudfront_distribution" "slack_metrics" {
  aliases         = ["sm.${var.base_host}"]
  comment         = "slack-metrics-${var.env}"
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"
  tags = {
    Name = "slack-metrics-${var.env}"
  }
  tags_all = {
    Env  = var.env
    Name = "slack-metrics-${var.env}"
  }
  wait_for_deployment = true
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
    target_origin_id         = "amplify-slack-metrics-${var.env}"
    viewer_protocol_policy   = "redirect-to-https"
    grpc_config {
      enabled = false
    }
  }
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    path_pattern           = "/static/*"
    target_origin_id       = "s3-slack-metrics-${var.env}"
    viewer_protocol_policy = "https-only"
    grpc_config {
      enabled = false
    }
  }
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "develop.dc6aqf8yivlbn.amplifyapp.com"
    origin_id           = "amplify-slack-metrics-${var.env}"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      ip_address_type          = "ipv4"
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "cp-slack-metrics-yoji-${var.env}.s3.ap-northeast-1.amazonaws.com"
    origin_access_control_id = "EGQB2P7IXCF2G"
    origin_id                = "s3-slack-metrics-${var.env}"
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:${var.account_id}:certificate/b3cfce13-6ff5-4989-bbcd-c2004ed47907"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_slack_metrics" {
  description                       = "Created by CloudFront"
  name                              = "s3-slack-metrics-stg"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
