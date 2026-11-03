resource "aws_ecr_repository" "db_migrator" {
  image_tag_mutability = "IMMUTABLE"
  name                 = "db-migrator-${var.env}"
}
resource "aws_ecr_lifecycle_policy" "db_migrator" {
  policy = jsonencode({
    rules = [{
      action = {
        type = "expire"
      }
      description  = "最新の3世代のイメージのみを保持"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
  region     = "ap-northeast-1"
  repository = "db-migrator-${var.env}"
}

resource "aws_ecr_repository" "slack_metrics" {
  image_tag_mutability = "IMMUTABLE"
  name                 = "slack-metrics-${var.env}"
}

resource "aws_ecr_lifecycle_policy" "slack_metrics" {
  policy = jsonencode({
    rules = [{
      action = {
        type = "expire"
      }
      description  = "最新の3世代のイメージのみを保持"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
  region     = "ap-northeast-1"
  repository = "slack-metrics-${var.env}"
}
