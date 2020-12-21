data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  role_name_prefix         = "${var.cluster_name}-${var.env}-${var.app}"
  tags                     = merge(var.tags, var.extra_tags)
  role_policy_resource_arn = "arn:${data.aws_partition.current.partition}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_name}/${var.env}/${var.app}/*"
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ttt-dev-kiam-server"
      ]
    }
  }
}

resource "aws_iam_role" "role-for-sa" {
  name               = "${local.role_name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags = merge(local.tags,
    {
      "Name"                                      = "${local.role_name_prefix}-role"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

data "aws_iam_policy_document" "ssmparams" {
  statement {
    effect = "Allow"
    actions = [
      "sts:GetCallerIdentity",
    ]
    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [local.role_policy_resource_arn]
  }
}

resource "aws_iam_policy" "ssmparams" {
  name   = "${local.role_name_prefix}-params"
  policy = join("", data.aws_iam_policy_document.ssmparams.*.json)
}

resource "aws_iam_policy_attachment" "ssmparams" {
  name       = "${local.role_name_prefix}-attachparams"
  roles      = [aws_iam_role.role-for-sa.name]
  policy_arn = join("", aws_iam_policy.ssmparams.*.arn)
}
