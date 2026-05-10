# backend.tf
terraform {
  backend "s3" {
    bucket = "clc15-renata-terraform"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}