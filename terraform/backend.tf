provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "ky-s3-terraform"
    key    = "ky-terraform-coaching-16.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.11"
}