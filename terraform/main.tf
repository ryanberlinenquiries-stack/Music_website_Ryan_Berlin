terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Partial backend config: bucket / key / region are passed at init time (see
  # README.md). S3-native locking needs no DynamoDB on Terraform >= 1.10.
  backend "s3" {
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Stack       = "music-website"
      ManagedBy   = "terraform"
      App         = "ryan-berlin-site"
      Component   = "frontend"
    }
  }
}

data "aws_caller_identity" "current" {}
