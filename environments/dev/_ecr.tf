resource "aws_ecr_repository" "ecr1" {
  name = "ecr1"
}

locals {
  prod_account_arn = ""
}

data "aws_iam_policy_document" "access_policy" {
  version = "2008-10-17"
  statement {
    sid = ""
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type        = "AWS"
      identifiers = [local.prod_account_arn]
    }
  }
}

resource "aws_ecr_repository_policy" "ecr1" {
  repository = aws_ecr_repository.ecr1.name
  policy     = data.aws_iam_policy_document.access_policy.json
}
resource "aws_ecr_repository" "ecr3" {
  name = "ecr3"
}

resource "aws_ecr_repository_policy" "ecr3_policy" {
  repository = aws_ecr_repository.ecr3.name
  policy     = data.aws_iam_policy_document.access_policy.json
}

resource "aws_ecr_repository" "ecr2" {
  name = "ecr2"
}

resource "aws_ecr_repository_policy" "ecr2-policy" {
  repository = aws_ecr_repository.ecr2.name
  policy     = data.aws_iam_policy_document.access_policy.json
}

resource "aws_ecr_repository" "ecr3" {
  name = "ecr3"
}

resource "aws_ecr_repository_policy" "ecr3_policy" {
  repository = aws_ecr_repository.ecr3.name
  policy     = data.aws_iam_policy_document.access_policy.json
}