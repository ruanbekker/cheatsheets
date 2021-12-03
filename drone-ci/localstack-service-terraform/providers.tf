terraform {
  required_providers {
    random = {
      version = "~> 3.0"
    }
    aws = {
      version = "~> 3.27"
      source = "hashicorp/aws"
    }
  }
}

provider "random" {}

provider "aws" {
  region                      = "eu-west-1"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb = "http://localstack:4566"
    kinesis  = "http://localstack:4566"
  }
}
