variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "web_tier_alb_name" {
  type = string
  default = "WebTierALB"
}

variable "app_tier_alb_name" {
  type = string
  default = "AppTierALB"
}
