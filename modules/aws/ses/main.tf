
resource "aws_sesv2_email_identity" "cloud_pratica" {
  email_identity = var.base_host
  region         = "ap-northeast-1"
  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}

resource "aws_sesv2_email_identity_mail_from_attributes" "cloud_pratica" {
  behavior_on_mx_failure = "USE_DEFAULT_VALUE"
  email_identity         = var.email_identity
  region                 = "ap-northeast-1"
}
