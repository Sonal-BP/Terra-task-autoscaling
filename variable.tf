variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {
  description = "Security group ID for Load Balancer"
  type        = string
}
