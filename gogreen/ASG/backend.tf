terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/ASG.tfstate"
    region = "us-west-1"
  }
}
