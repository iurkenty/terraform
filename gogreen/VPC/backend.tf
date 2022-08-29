terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/VPC.tfstate"
    region = "us-west-1"
  }
}
