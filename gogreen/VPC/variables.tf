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
