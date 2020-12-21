variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "app" {
  description = "Name of the application"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "environment" {
  description = "Environment where code is getting deployed"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags for IAM role"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra optional tags"
  type        = map(string)
  default     = {}
}

variable "db_instance_class" {
  description = "Instance class for the DB"
  type        = string
  default     = "db.r5.large"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "db_subnet_group" {
  type        = string
  description = "Subnet group name for DB cluster instance"
}

variable "security_group" {
  type        = string
  description = "security group allowed to access the DB cluster (sg-12345)"
}

variable "mgmt_vpc_cidr_block" {
  type        = list(object({ CIDRBlock = string, Description = string }))
  description = "CIDR block allowed to access the DB cluster (0.0.0.0)"
}