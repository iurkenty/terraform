terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/IAM.tfstate"
    region = "us-west-1"
  }
}
