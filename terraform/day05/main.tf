
# Create a S3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region     = var.region
  tags = {
    Environment = var.environment
    Name        = local.vpc_name
  }
}

resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"
  region        = var.region
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}

