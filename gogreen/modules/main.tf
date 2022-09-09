## cloud-init user_data practice
provider "aws" {
  region = "us-west-2"
}

data "template_file" "user_data" {
  template = file("../../../learn-terraform-provisioning/scripts/add-ssh-web-app.yaml")
}

data "aws_ami" "ami-test" {
  most_recent = true
  owners      = ["amazon"]

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

resource "aws_default_subnet" "cloud-init-test" {
  availability_zone = "us-west-2a"
}

data "aws_security_group" "default" {
  id = "sg-0d78ac2b350e8f84f"
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ami-test.id
  instance_type = "t2.micro"
  subnet_id = aws_default_subnet.cloud-init-test.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  associate_public_ip_address = true
  user_data = data.template_file.user_data.rendered

}