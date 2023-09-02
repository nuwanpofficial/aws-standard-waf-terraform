terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1"
    }
    random = {
      version = "3.4"
    }
  }

  backend "s3" {
    bucket         = ""
    key            = ""
    region         = ""
    encrypt        = true
    dynamodb_table = ""
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      environment  = var.environment
      creator      = var.creator
      managedby    = "terraform"
      project-name = var.project_name
      ticket-id    = var.ticket_id
      product      = var.product
      # application  = var.application
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  alias   = "use1"
  profile = var.aws_profile
}
