provider "aws" {
  region = var.aws_region
}


data "aws_ami" "web-tier-ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = [
    "amzn2-ami-hvm-*-gp2",
    ]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
locals {
  tag2 = {
      key = "Name"
      value = "WebTierASG"
      propagate_at_launch = true
 }
}

resource "aws_iam_service_linked_role" "WebTierASGRole" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = var.WebTierAutoscalingName

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
module "WebTierAutoScaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  name    = var.WebTierAutoscalingName

  vpc_zone_identifier = module.vpc.public_subnets
  service_linked_role_arn = aws_iam_service_linked_role.WebTierASGRole.arn

  target_group_arns = [] ## ALB arn

  use_name_prefix = false
  instance_name = var.WebTierAutoscalingName

  min_size         = 0
  max_size         = 6
  desired_capacity = 3
  wait_for_capacity_timeout = 0
  health_check_type = "ELB"
  health_check_grace_period = 300

  create_iam_instance_profile = false


## Launch Template
  launch_template_name = "GoGreen-${var.WebTierAutoscalingName}"
  update_default_version = true

  image_id          = data.aws_ami.web-tier-ami.id
  instance_type     = var.free-tier-EC2
  user_data         = filebase64("userdata-basic.sh")
  ebs_optimized     = false
  enable_monitoring = true
  security_groups = [module.WebTierSecurityGroup.security_group_id]

  tags = local.tag2
}

## Web Tier Application Load Balancer

module "WebTierALB" {
  source = ""
}
