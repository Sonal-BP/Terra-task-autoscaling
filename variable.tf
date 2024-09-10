variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}
