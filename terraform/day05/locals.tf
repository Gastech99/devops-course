locals {
  bucket_name = "${var.channel-name}-bucket-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}