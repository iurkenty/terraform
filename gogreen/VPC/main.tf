provider "aws" {
  region = "us-east-1"
}
#to reference a module output use the following
#vpc_security_group_ids = [module.sgmodule(name).sg_id(output name)]