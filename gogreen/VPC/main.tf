provider "aws" {
  region = var.aws_region
}

locals {
  name   = "VPC-GoGreen"
  region = "us-west-2"
  tags   = {
    Owner       = "GeneralAdminus"
    Environment = "Testing"
    Name        = "GoGreenVPC"
  }
}
//noinspection MissingModule
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = local.name
  cidr = "20.16.0.0/16"

  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets  = ["20.16.32.0/20", "20.16.96.0/20", "20.16.160.0/20"]
  public_subnets   = ["20.16.48.0/20", "20.16.112.0/20", "20.16.176.0/20"]
  database_subnets = ["20.16.16.0/20", "20.16.80.0/20", "20.16.144.0/20"]
  intra_subnets    = ["20.16.0.0/20", "20.16.64.0/20", "20.16.128.0/20"]

  private_subnet_suffix  = var.application-sn
  public_subnet_suffix   = var.web-tier-sn
  database_subnet_suffix = var.data-base-sn
  intra_subnet_suffix    = var.spare-sn

  create_database_subnet_group      = true
  create_database_nat_gateway_route = true

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  enable_dns_hostnames   = true
  enable_dns_support     = true

  enable_nat_gateway         = true
  single_nat_gateway         = false
  one_nat_gateway_per_az     = true


  tags = local.tags
  private_subnet_tags = {
    Name = var.application-sn
  }
  public_subnet_tags = {
    Name = var.web-tier-sn
  }
  database_subnet_tags = {
    Name = var.data-base-sn
  }
  intra_subnet_tags    = {
    Name = var.spare-sn
  }

}

module "WebTierSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
}