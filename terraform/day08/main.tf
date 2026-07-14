resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  region        = tolist(var.allowed_region)[0]

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
}


resource "aws_autoscaling_group" "app_servers" {
  name               = "app-servers-asg"
  max_size           = 5
  min_size           = 1
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-server-asg"
    propagate_at_launch = true
  }
}
