terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/RDS.tfstate"
    region = "us-west-1"
  }
}
