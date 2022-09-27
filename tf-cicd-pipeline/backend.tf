terraform {
  backend "s3" {
    bucket = "terraform-states-iurkenty"
    key    = "dev/WebHostingProject.tfstate"
    region = "us-west-1"
  }
}
