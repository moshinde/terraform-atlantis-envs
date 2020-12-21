variable "aws_region" {
  description = "AWS Region to use"
  default     = "us-east-1"
}

variable "cluster" {
  description = "Cluster name (should be kept [a-zA-z-_])"
}

variable "env" {
  description = "Environment name (should be kept [a-zA-z-_])"
}

variable "app" {
  description = "App name (should be kept [a-zA-z-_])"
}

variable "kiam_server_role" {
  description = "role for provisioning scheduling resources"
}

# MessageBus
variable "message_bus_group_id" {
  description = "The Kafka Subscrition Group Id"
}
variable "message_bus_servers" {
  description = "The Kafka Subscription servers"
}

variable "eks_cluster_backend_bucket" {
  description = ""
}

variable "eks_cluster_backend_dynamodb_table" {
  description = ""
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "db_subnet_group" {
  description = "Subnet group name for DB cluster instance"
}

variable "db_instance_type" {
  description = "DB instance type"
  type        = string
}

variable "allocated_storage" {
  description = "Number GB of storage to allocate for the DB"
  type        = number
}

variable "mgmt_vpc_cidr_block" {
  description = "CIDR block allowed to access the DB cluster (0.0.0.0)"
}

variable "security_group" {
  description = "security group allowed to access the DB cluster (sg-12345)"
}

variable "multi_az" {
  description = "Whether or not this should be multi-az"
  type        = bool
  default     = true
}