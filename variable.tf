variable "region" {
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c2af51e265bd5e0e"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the ASG"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  default     = 1
}
