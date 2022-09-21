
locals {
  name   = "VPC-GoGreen"
  region = "us-west-2"
  tags   = {
    Owner       = "GeneralAdminus"
    Environment = "Testing"
    Name        = "GoGreenVPC"
  }
}
## GoGreen main VPC with 4 subnets for Web, App, and DB tiers plus a spare subnet.
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

  enable_nat_gateway         = false
  single_nat_gateway         = false
  one_nat_gateway_per_az     = false


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

/*
data "aws_vpc" "default" {
  default = true
}
*/
## Web Tier ALB Security Group
module "WebALBSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ALB-SG-GoGreen"
  description = "Application load balancer security group with all ports open within VPC"
  vpc_id      = module.vpc.vpc_id ## data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

}
## Web Tier Security Group
module "WebTierSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"

  name = "Web-SG-GoGreen"
  description = "Web tier security group with ALB-SG as a source"
  vpc_id = module.vpc.vpc_id ## data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [
    {
      rule = "http-80-tcp"
      source_security_group_id = module.WebALBSecurityGroup.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}

## Application Tier Load Balancer Security Group
module "AppALBSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"

  name = "App-ALB-SG-GoGreen"
  description = "Application tier load balancer security group"
  vpc_id =  module.vpc.vpc_id ## data.aws_vpc.default.id ##

 computed_ingress_with_cidr_blocks = [
    {
      rule = "http-80-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block ## data.aws_vpc.default.id <for testing>##
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}
## Application Tier Security Group
module "AppTierSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"

  name = "App-SG-GoGreen"
  description = "Application tier security group with Web-SG as a source"
  vpc_id = module.vpc.vpc_id ## data.aws_vpc.default.id ##

  computed_ingress_with_source_security_group_id = [
    {
      rule = "http-80-tcp"
      source_security_group_id = module.AppALBSecurityGroup.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}

## Data-base Tier Security Group
module "DBSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"

  name = "DB-SG-GoGreen"
  description = "Data-base Security Group with App-SG as a source"
  vpc_id = module.vpc.vpc_id ## data.aws_vpc.default.id ##

  computed_ingress_with_source_security_group_id = [
    {
      rule = "mysql-tcp"
      source_security_group_id = module.AppTierSecurityGroup.security_group_id
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}