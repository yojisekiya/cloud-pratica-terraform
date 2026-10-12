provider "aws" {
  region  = "ap-northeast-1"
  profile = "cp-terraform-stg" // ← ここ

  default_tags {
    tags = {
      Env = "stg"
    }
  }
}
