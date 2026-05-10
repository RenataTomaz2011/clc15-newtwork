terraform {
  backend "s3" {
    bucket = "clc15-renata-terraform"
    key    = "newtwork/terraform.tfstate"
    region = "us-east-1"
  }
}
