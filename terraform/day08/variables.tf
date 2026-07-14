variable "environment" {
  default = "dev"
  type    = string

}

variable "channel-name" {
  default = "gastech"
}

variable "allowed_region" {
  type        = list(string)
  description = "The AWS regions to create resources in"
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "monitoring-enabled" {
  description = "Enable detailed monitoring for the EC2 instance"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Associate public IP address with EC2 instances"
  type        = bool
  default     = true
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}


variable "allowed_vm_types" {
  description = "List of allowed EC2 instance types"
  type        = list(string)
  default     = ["t2.micro", "t3.micro", "t3a.micro"]
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-EC2-Instance"
    Project     = "TerraformDemo"
    created_by  = "Terraform"
  }
}

variable "ingress_value" {
  description = "The ingress value for the security group"
  type        = tuple([number, string, number])
  default     = [443, "tcp", 443]
}

variable "config" {
  type = object({
    region             = string
    instance_count     = number
    monitoring_enabled = bool
  })

  default = {
    region             = "us-east-1"
    instance_count     = 1
    monitoring_enabled = true
  }
}


variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["mybucket-gastech-terraform-course", "mybucket-gastech-terraform-course2"]
}