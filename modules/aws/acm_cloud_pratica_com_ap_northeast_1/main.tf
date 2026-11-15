resource "aws_acm_certificate" "main" {
  domain_name               = "*.stg.yojisekiya.com"
  key_algorithm             = "RSA_2048"
  region                    = "ap-northeast-1"
  subject_alternative_names = ["*.${var.base_host}"]
  validation_method         = "DNS"
}
