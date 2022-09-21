
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

  target_group_arns = module.AppTierALB.target_group_arns ## ALB arn

  use_name_prefix = false
  instance_name = var.AppTierAutoscalingName

  min_size                  = 0
  max_size                  = 6
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  health_check_grace_period = 300

  create_iam_instance_profile = false
  iam_instance_profile_arn    = data.aws_iam_instance_profile.EC2.arn

## Launch Template
  launch_template_name   = "GoGreen-${var.AppTierAutoscalingName}"
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

## App Tier Load Balancer

module "AppTierALB" {
  source  = "terraform-aws-modules/alb/aws"

  name = element(var.ALB-Names, 1) ## used element function here just for fun
  load_balancer_type = "application"
  internal = true

  vpc_id          = module.vpc.vpc_id
  security_groups = module.AppALBSecurityGroup.security_group_id
  subnets         = module.vpc.private_subnets

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }]

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 100
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "www.youtube.com"
        path        = "/watch"
        query       = "v=zpIbBOdQ0qw"
        protocol    = "HTTPS"
      }]
      conditions = [{
        query_strings = [{
          key   = "video"
          value = "trock"
        }]
      }]
    }]
  target_groups = [
    {
      name_prefix          = "App"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"

    }]
  tags = {
    Project = "GoGreen"
  }
  lb_tags = {
    AppTierALB = "GoGreen"
  }
  target_group_tags = {
    AppTierTargetGroup = "GoGreen"
  }
  http_tcp_listeners_tags = {
    AppTierHTTPListener = "GoGreen"
  }
}
