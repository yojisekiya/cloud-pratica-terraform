terraform {
  required_version = "~> 1.14.1" // 1.14.1 以上 1.15.0 未満 を許容

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.34.0" // 6.34.0 以上 6.35.0 未満 を許容
    }
  }
}
