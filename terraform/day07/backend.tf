terraform {
  backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
