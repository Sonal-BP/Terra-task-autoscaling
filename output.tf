
output "autoscaling_group_id" {
  value = aws_autoscaling_group.nginx-asg.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.nginx-asg.name
}
