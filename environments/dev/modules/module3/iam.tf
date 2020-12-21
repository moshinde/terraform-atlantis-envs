data "aws_caller_identity" "current" {}

locals {
  param_prefix = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter"
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = [
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "${local.param_prefix}/${var.cluster}/${var.env}/shared/AppSettings*",
      "${local.param_prefix}/${var.cluster}/${var.env}/${var.app}/AppSettings*",
      "${local.param_prefix}/${var.cluster}/${var.env}/${var.app}/*",
      "${local.param_prefix}/shared/AppSettings*",
      "${local.param_prefix}/shared/new_relic/*",
      "${local.param_prefix}/shared/rancher/*"
    ]
  }
}

data "aws_iam_policy_document" "kiam_server_role_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster}-kiam-server"
      ]
    }
  }
}

resource "aws_iam_role" "kiam_server_role" {
  name               = "${var.cluster}-${var.env}-${var.app}-role"
  assume_role_policy = data.aws_iam_policy_document.kiam_server_role_document.json
}

resource "aws_iam_role_policy" "policy" {
  name   = "${var.cluster}-${var.env}-${var.app}-policy"
  role   = aws_iam_role.kiam_server_role.id
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role" "database_role" {
  name = "${var.cluster}-${var.env}-${var.app}-database-role"

  tags = merge(var.database_tags,
    {
      "Name"                                 = "${var.cluster}-${var.env}-${var.app}-database-role"
      "Cluster"                              = var.cluster
      "kubernetes.io/cluster/${var.cluster}" = "owned"
      "Service"                              = ""
    },
  )

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.kiam_server_role}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
