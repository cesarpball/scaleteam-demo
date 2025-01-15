terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "<your_bucket_name>"
    key            = "<your_state_key>"
    dynamodb_table = "<your_dynamo_db_table>"
    region         = "eu-west-1"
  }
}