terraform {

    backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a S3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "gastech-terraform-course-bucket"

  tags = {
    Name        = "Demo S3 Bucket"
    Environment = "Dev"
  }
}
