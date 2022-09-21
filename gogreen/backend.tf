terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/terraform.tfstate"
    region = "us-west-1"
  }
}
