# Launch resources in different regions use alias = "name"
/*
provider "aws" {
  region     =  "us-west-1"
}
provider "aws" {
  alias      =  "aws02"
  region     =  "ap-south-1"
*/

# Launch resources in a different account use profile = "name"
# Account credentials must be stored in the providers(aws) config file
/*
provider "aws" {
  alias      =  "aws02"
  region     =  "ap-south-1"
  profile    =  "account02"
}
*/

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "EC2-test" {
  ami = "ami-0cea098ed2ac54925"
  instance_type = "t2.micro"
}
/*
module "ASG" {
  source = "github.com/terraform-aws-modules/terraform-aws-autoscaling"
  name   = ""
}
*/
