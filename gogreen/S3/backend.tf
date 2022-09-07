terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/S3.tfstate"
    region = "us-west-1"
  }
}
