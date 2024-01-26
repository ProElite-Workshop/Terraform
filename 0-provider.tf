provider "aws" {
  region = "us-east-1"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }

}