terraform {
  # minimum allowed version
  required_version = ">= 0.12.20"
  required_providers {
    aws    = "~> 2.65.0"
    random = ">= 2.2.1"
  }
  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "monica-dev"
    key            = "clusters/ttt-dev/environments/dev/apps/module1/terraform.tfstate"
    dynamodb_table = "terraform-locks-development"
  }
}