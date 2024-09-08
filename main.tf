provider "aws" {
  region = "us-west-2"
}

# Auto Scaling Launch Configuration
resource "aws_launch_configuration" "app" {
  name_prefix          = "app-"
  image_id             = "ami-0075013580f6322a1"  # Ensure this AMI has the required OS
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.allow_all.id]
  user_data            = <<-EOF
                            #!/bin/bash
                            sudo apt-get update
                            sudo apt-get install -y nginx
                            sudo systemctl start nginx
                            sudo systemctl enable nginx
                            EOF
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.private_subnet_1.id]
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app.name
}
