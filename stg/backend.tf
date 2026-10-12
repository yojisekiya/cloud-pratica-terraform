terraform {
  backend "s3" {
    bucket = "cp-terraform-yoji-stg"
    key    = "main.tfstate"
    region = "ap-northeast-1"
  }
}
