provider "aws" {
  region = "us-east-1"
}

variable "vpcname" {
  type = string
  default = "myvpc"
}

variable "sshport" {
  type = number
  default = 22
}

variable "enable" {
  default = true
}

variable "mylist" {
  type = list(string)
  default = [ "Value1","Value2"]
}

variable "mymap" {
  type = map 
  default = {
    Key1 = "Value1"
    Key2 = "Value2"
  }
}

variable "inputname" {
  type = string
  description = "Set a name for VPC"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.inputname 
  }
}

output "vpcid" {
  value = aws_vpc.myvpc.id
}

variable "mytuple" {
  type = tuple([string, number, string])
  default = ["cat1", 1, "dog"]
}

variable "myobject"
  type = object({ name = string, port = list(number) })
  default = {
    name = "IV"
    port = [sshport, 25, 80] 
}

resource "aws_ec2" "testec2" {

}