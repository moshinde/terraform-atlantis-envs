env                                = "dev"
app                                = "aap1"
cluster_name                       = "ttt-dev"
aws_region                         = "us-east-1"
eks_cluster                        = "ttt-dev"
eks_cluster_backend_bucket         = "monica-dev"
eks_cluster_backend_key            = "clusters/ttt-dev/resources/cluster/terraform.tfstate"
eks_cluster_backend_dynamodb_table = "terraform-locks-development"
tags = {
  Owner        = "Team Monica"
  BusinessUnit = "TTT"
  Environment  = "Development"
  Application  = "appp1"
  Service      = "APPServiceV2"
}
module2messagebusserver = ""
extra_allowed_cidr = [
                  {
                    CIDRBlock   = "10.7.6.0/23"
                    Description = "RAVPnhN"
                  },
                  {
                    CIDRBlock   = "10.10.8.0/24"
                    Description = "RAVbiuPN"
                  }
                ]
module3messagebusserver     = ""

# MessageBus
message_bus_group_id          = "groupbus"