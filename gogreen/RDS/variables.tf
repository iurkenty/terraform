variable "aws_region" {
  description = "AWS Region for GoGreen"
  type = string
  default = "us-west-2"
}

variable "spare-sn" {
  description = "Spare subnet name"
  type = string
  default = "SpareSN"
}

variable "data-base-sn" {
  description = "Database subnet name"
  type = string
  default = "DataBaseSN"
}

variable "application-sn" {
  description = "Application subnet name"
  type = string
  default = "AppSN"
}

variable "web-tier-sn" {
  description = "Web-tier subnet name"
  type = string
  default = "WebSN"
}

variable "cidr" {
  description = "CIDR block"
  type = string
  default = "20.16.0.0/16"
}

variable "ProjectName" {
  type = string
  default = "GoGreen"
}

variable "WebTierAutoscalingName" {
  description = "Autoscaling group name for the Web-Tier"
  type = string
  default = "WebTierASG"
}
variable "AppTierAutoscalingName" {
  description = "Autoscaling group name for the App-Tier"
  type = string
  default = "AppTierASG"
}

variable "free-tier-EC2" {
  type = string
  default = "t2.micro"
}


variable "ALB-Names" {
  description = "Load Balancer names for each tier"
  type = list(string)
  default = ["WbeTierALB", "AppTierALB"]
}

variable "domain-name" {
  type = string
  default = "leo-kroshus.net"
}

variable "rds" {
  description = ""
}













