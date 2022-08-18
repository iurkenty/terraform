provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2test" {
  ami = "ami-sa212"
  instance_type = "t.2micro"

}