
data "aws_iam_instance_profile" "EC2" {
  name = "AppTierEC2Profile"
}

data "aws_ami" "app-tier-ami" {
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
  tag1 = {
    key = "Name"
    value = "AppTierASG"
    propagate_at_launch = true
  }
}

resource "aws_iam_service_linked_role" "AppTierASGRole" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = var.AppTierAutoscalingName

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
module "AppTierAutoScaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  name    = var.AppTierAutoscalingName

  vpc_zone_identifier = module.vpc.private_subnets
  service_linked_role_arn = aws_iam_service_linked_role.AppTierASGRole.arn

  target_group_arns = [] ## ALB arn

  use_name_prefix = false
  instance_name = var.AppTierAutoscalingName

  min_size         = 0
  max_size         = 6
  desired_capacity = 3
  wait_for_capacity_timeout = 0
  health_check_type = "ELB"
  health_check_grace_period = 300

  create_iam_instance_profile = false
  iam_instance_profile_arn = data.aws_iam_instance_profile.EC2.arn

## Launch Template
  launch_template_name = "GoGreen-${var.AppTierAutoscalingName}"
  update_default_version = true

  image_id          = data.aws_ami.app-tier-ami.id
  instance_type     = var.free-tier-EC2
  user_data         = filebase64("../userdata.sh")
  ebs_optimized     = false
  enable_monitoring = true
  security_groups = [module.AppTierSecurityGroup.security_group_id]

/*
  lifecycle = {
    create_before_destroy = true
  }
*/
  tags = local.tag1
}
