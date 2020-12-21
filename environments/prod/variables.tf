variable "aws_region" {
  description = "AWS Region to use"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "app" {
  type        = string
  description = "Name of the application"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type        = map(string)
  description = "Tags for IAM role"
  default     = {}
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra optional tags"
  default     = {}
}

variable "eks_cluster_backend_bucket" {
  type        = string
  description = ""
}

variable "eks_cluster_backend_key" {
  type        = string
  description = ""
}

variable "eks_cluster_backend_dynamodb_table" {
  type        = string
  description = ""
}

variable "eks_cluster" {
  type        = string
  description = "Name of AWS EKS Cluster"
}

variable "extra_allowed_cidr" {
  type        = list(object({ CIDRBlock = string, Description = string }))
  description = "CIDR block allowed to access the DB cluster (0.0.0.0)"
}

variable "message_bus_group_id" {
  type        = string
  description = "Messagebus server details for Kafka GroupID"
}