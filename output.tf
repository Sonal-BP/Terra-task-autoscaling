output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_tg_1.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb_1.dns_name
}
