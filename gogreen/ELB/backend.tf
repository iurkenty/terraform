terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/ELB.tfstate"
    region = "us-west-1"
  }
}
