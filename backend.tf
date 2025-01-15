terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-cesarpball"
    key            = "scale"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-1"
  }
}