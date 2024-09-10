resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_launch_configuration" "nginx-launch_config" {
  name          = "nginx-launch-config"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.ec2_sg.id]

  lifecycle {
    create_before_destroy = true
  }

       user_data            = <<-EOF
                            #!/bin/bash
                            sudo apt-get update
                            sudo apt-get install -y nginx
                            sudo systemctl start nginx
                            sudo systemctl enable nginx
                            EOF
}

resource "aws_autoscaling_group" "nginx-asg" {
  launch_configuration = aws_launch_configuration.nginx-launch_config.id
  vpc_zone_identifier  = var.private_subnet_ids
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
  target_group_arns     = [var.target_group_arn]
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.name
}
