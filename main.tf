resource "aws_lb_target_group" "alb_tg_1" {
  name        = "alb-tg-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
 
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
 
  tags = {
    Name = "app-tg"
  }
}

resource "aws_lb" "alb_1" {
  name               = "alb-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout                = 60
  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.alb_tg_1.arn
      }
    }
  }
}
