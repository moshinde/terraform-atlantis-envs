provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    region         = var.aws_region
    bucket         = var.eks_cluster_backend_bucket
    key            = var.eks_cluster_backend_key
    dynamodb_table = var.eks_cluster_backend_dynamodb_table
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region         = var.aws_region
    bucket         = var.eks_cluster_backend_bucket
    key            = "clusters/${var.eks_cluster}/resources/vpc/terraform.tfstate"
    dynamodb_table = var.eks_cluster_backend_dynamodb_table
  }
}

locals {
  tags = merge(var.tags, var.extra_tags)
}

module "modue1" {
  source = "./modules/module1"

  aws_region            = var.aws_region
  cluster_name          = var.cluster_name
  app                   = var.app
  env                   = var.env
  vpc_id                = data.terraform_remote_state.eks_cluster.outputs.vpc_id
  db_subnet_group       = data.terraform_remote_state.eks_cluster.outputs.db_subnet_group
  security_group        = data.terraform_remote_state.eks_cluster.outputs.eks_worker_security_group
  kiam_server_role      = data.terraform_remote_state.eks_cluster.outputs.kiam_server_role
  tags                  = local.tags
  messagebuskafkaserver = var.module2messagebusserver
}
module "module2" {
  source          = "./modules/module2"
  cluster_name    = var.cluster_name
  app             = "module2service"
  env             = var.env
  vpc_id          = data.terraform_remote_state.eks_cluster.outputs.vpc_id
  db_subnet_group = data.terraform_remote_state.eks_cluster.outputs.db_subnet_group
  security_group  = data.terraform_remote_state.eks_cluster.outputs.eks_worker_security_group
  mgmt_vpc_cidr_block = concat([
    {
      CIDRBlock   = data.terraform_remote_state.eks_cluster.outputs.mgmt_vpc_cidr_block
      Description = "Management VPC"
    }
    ],
    var.extra_allowed_cidr
  )
  tags = merge(var.tags, {
    Owner       = "Team Monica"
    Application = "module2"
    Service     = "module2"
  })
}

#Database instance for the environment
module "db_instance" {
  source                             = "./modules/module2-db"
  aws_region                         = var.aws_region
  vpc_id                             = data.terraform_remote_state.eks_cluster.outputs.vpc_id
  cluster                            = var.eks_cluster
  env                                = var.env
  app                                = "module2"
  db_subnet_group                    = data.terraform_remote_state.eks_cluster.outputs.db_subnet_group
  mgmt_vpc_cidr_block                = data.terraform_remote_state.eks_cluster.outputs.mgmt_vpc_cidr_block
  security_group                     = data.terraform_remote_state.eks_cluster.outputs.eks_worker_security_group
  kiam_server_role                   = data.terraform_remote_state.eks_cluster.outputs.kiam_server_role
  eks_cluster_backend_bucket         = var.eks_cluster_backend_bucket
  eks_cluster_backend_dynamodb_table = var.eks_cluster_backend_dynamodb_table
  db_instance_type                   = "db.r5.large"
  allocated_storage                  = 200
  multi_az                           = false
  database_tags = merge(var.tags, {
    Owner       = "Team Monica"
    Application = "module2"
    Service     = "module2"
  })
}
module "module3" {
  source          = "./modules/module3"
  cluster_name    = var.cluster_name
  app             = "module3service"
  env             = var.env
  vpc_id          = data.terraform_remote_state.eks_cluster.outputs.vpc_id
  db_subnet_group = data.terraform_remote_state.eks_cluster.outputs.db_subnet_group
  security_group  = data.terraform_remote_state.eks_cluster.outputs.eks_worker_security_group
  mgmt_vpc_cidr_block = concat([
    {
      CIDRBlock   = data.terraform_remote_state.eks_cluster.outputs.mgmt_vpc_cidr_block
      Description = "Management VPC"
    }
    ],
    var.extra_allowed_cidr
  )
  tags = merge(var.tags, {
    Owner       = "Team Monica"
    Application = "Module3"
    Service     = "Module3"
  })
}